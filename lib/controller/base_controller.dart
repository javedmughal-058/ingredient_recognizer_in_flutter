import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ingredient_recognizer_in_flutter/services/text_recognizer/mlKit_recognizer.dart';
import 'package:ingredient_recognizer_in_flutter/services/text_recognizer/text_recognizer.dart';
import 'package:ingredient_recognizer_in_flutter/services/text_recognizer/text_recognizer_response.dart';
import 'package:ingredient_recognizer_in_flutter/utils/constant/helper.dart';

class BaseController extends GetxController {
  var currentIndex = 0.obs;

  var image = Rx<File?>(null);
  var errorMessage = "".obs;
  var loadingMsg = "".obs;
  var isLoading = false.obs;
  var ingredientNotFound = false.obs;
  var isFinalButtonShow = false.obs;
  var finalResult = "".obs;

  //Text Recognition
  RecognitionResponse? responseText;
  var recognizeText = "".obs;
  var numberOfLine = 0.obs;
  late TextEditingController textController;

  //Object Recognition
  var listOfObject = <String>[].obs;
  var ingredientsList = <String>[].obs;
  var ingredientsListText = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
  }

  getPhoto(BuildContext context, ImageSource source) async {
    XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      errorMessage.value = "";
      listOfObject.clear();
      ingredientsList.clear();
      ingredientNotFound.value = false;
      recognizeText.value = "";
      // textController.text = "";
      image.value = File(file.path);
      await cropImage();
    } else {
      if (image.value == null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Helper.showErrorAlert(context, msg: "Image is not selected");
        });
      }
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: image.value!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      compressQuality: 100,
      compressFormat: ImageCompressFormat.png,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Helper.secondaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            activeControlsWidgetColor: Helper.primaryColor),
      ],
    );

    if (croppedImage != null) {
      // debugPrint("Image Cropped");
      image.value = File(croppedImage.path);
      isFinalButtonShow.value = false;
      finalResult.value = "";
    }
  }

  Future<void> processingOnImage(context) async {
    finalResult.value = "";
    ingredientNotFound.value = false;
    isFinalButtonShow.value = false;
    isLoading.value = true;
    loadingMsg.value = "Recognizing Text...!";
    debugPrint("Loading $loadingMsg");
    late ITextRecognizer recognizer = MLKitTextRecognizer();
    recognizeText.value = await recognizer.processImage(image.value!.path);
    numberOfLine.value = (recognizeText.value.length / 25).ceil();
    // textController.text = recognizeText.value;
    // responseText = RecognitionResponse(imgPath: image.value!.path, recognizedText: recognizeText.value);
    Future.delayed(const Duration(milliseconds: 0), () async {
      if (recognizeText.value != "" && recognizeText.value.contains('ingredients') ||
          recognizeText.value.contains('ingredient') ||
          recognizeText.value.contains('Ingredients') ||
          recognizeText.value.contains('Ingredient')) {
        var splitResponse = recognizeText.value.split('.').first;
        do {
          if (splitResponse.contains('ingredients')) {
            splitResponse = splitResponse.split('ingredients').last.trim();
          }
          else if (splitResponse.contains('ingredient')) {
            splitResponse = splitResponse.split('ingredient').last.trim();
          }
          else if (splitResponse.contains('Ingredient')) {
            splitResponse = splitResponse.split('Ingredient').last.trim();
          }
          else if (splitResponse.contains('Ingredients')) {
            splitResponse = splitResponse.split('Ingredients').last.trim();
          }
        }
        while (splitResponse.contains('ingredients') ||
            splitResponse.contains('ingredient') ||
            splitResponse.contains('Ingredients') ||
            splitResponse.contains('Ingredient'));

        debugPrint("New $splitResponse");
        textController.text = splitResponse;
      }
      else{
        recognizeText.value = "";
        errorMessage.value = "No Ingredients Found, Try different Image";
      }

      ///old working
      // else{
      //   var ingredientsListFromFile = await readLabelsFromAsset();
      //   // debugPrint("File data $ingredientsListFromFile");
      //   var splitList = recognizeText.value.split(' ').toList();
      //
      //   ///Remove following symbols
      //   var symbolFreeList = splitList.map((word) {
      //     return word.replaceAll(RegExp(r'[,.:!@#$%^&*()_+=/\\-]'), '');
      //   }).toList();
      //
      //   var ingredientFindList = <String>[];
      //
      //   debugPrint("Symbol free $symbolFreeList");
      //   ///Remove Duplicate Strings
      //   for(int i = 0; i<symbolFreeList.length; i++){
      //     if (symbolFreeList[i].endsWith('s')) {
      //       symbolFreeList[i] = symbolFreeList[i].substring(0, symbolFreeList[i].length - 1); // Remove the 's' at the end
      //     }
      //     if(!ingredientFindList.contains(symbolFreeList[i].toLowerCase())){
      //       ingredientFindList.add(symbolFreeList[i].toLowerCase());
      //     }
      //   }
      //
      //   debugPrint("Duplicate free Text $ingredientFindList");
      //   ingredientsListText.value = filterIngredients(
      //       listFromFile: ingredientsListFromFile, ingredientFind: ingredientFindList);
      //   debugPrint("Filter Text $ingredientsListText");
      // }
    });
  }

  Future<List<String>> readLabelsFromAsset() async {
    String content = await rootBundle.loadString('assets/model/ingredient.txt');
    List<String> labels = content.split('\n');
    labels = labels.map((label) => label.trim()).toList();
    // Remove empty lines or lines with special characters
    labels.removeWhere(
        (label) => label.isEmpty || label.contains(RegExp(r'[^A-Za-z\s]')));
    return labels;
  }

  List<String> filterIngredients(
      {required List<String> listFromFile,
      required List<String> ingredientFind}) {
    return ingredientFind.where((item) {
      return listFromFile.contains(item);
    }).toList();
  }

  void makeFinalResult(){
    isFinalButtonShow.value = false;
    finalResult.value = textController.text;
  }
}
