import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ingredient_recognizer_in_flutter/services/text_recognizer/mlKit_recognizer.dart';
import 'package:ingredient_recognizer_in_flutter/services/text_recognizer/text_recognizer.dart';
import 'package:ingredient_recognizer_in_flutter/services/text_recognizer/text_recognizer_response.dart';
import 'package:ingredient_recognizer_in_flutter/utils/constant/helper.dart';
import 'package:ingredient_recognizer_in_flutter/utils/loader/custom_loader.dart';

class BaseController extends GetxController {

  var currentIndex = 0.obs;

  var image = Rx<File?>(null);
  var errorMessage = "".obs;
  var loadingMsg = "".obs;
  var isLoading = false.obs;
  var ingredientNotFound = false.obs;

  //Text Recognition
  RecognitionResponse? responseText;
  var recognizeText = "".obs;
  var numberOfLine = 0.obs;
  late TextEditingController textController;

  //Object Recognition
  var listOfObject = <String>[].obs;
  var ingredientsList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
    loadModel();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  getPhoto(BuildContext context, ImageSource source) async {
    XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      errorMessage.value = "";
      listOfObject.clear();
      ingredientsList.clear();
      ingredientNotFound.value = false;
      recognizeText.value = "";
      textController.text = "";
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
    }
  }

  Future<void> processingOnImage(context) async {
    ingredientNotFound.value = false;
    isLoading.value = true;
    loadingMsg.value = "Recognizing Text...!";
    debugPrint("Loading $loadingMsg");
    late ITextRecognizer recognizer = MLKitTextRecognizer();
    recognizeText.value = await recognizer.processImage(image.value!.path);
    numberOfLine.value = (recognizeText.value.length / 25).ceil();
    textController.text = recognizeText.value;
    // responseText = RecognitionResponse(imgPath: image.value!.path, recognizedText: recognizeText.value);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (recognizeText.value == "") {
        errorMessage.value = "No Text Found, Try different Image";
      }
    });
  }

  //object recognizer using Tflite
  Future<void> objectDetector() async {
    loadingMsg.value = "Recognizing Ingredient...!";
    try {
      var detector = await Tflite.runModelOnImage(
          path: image.value!.path,   // required
          imageMean: 0.0,   // defaults to 117.0
          imageStd: 255.0,  // defaults to 1.0
          numResults: 2,    // defaults to 5
          threshold: 0.2,   // defaults to 0.1
          asynch: true      // defaults to true
      );
      if (detector != null) {
        debugPrint("idr........!");
        listOfObject.clear();
        // if(detectedObjects["confidence"]*100 > 45){
        for (var result in detector) {
          listOfObject.add(result["label"].toString());
        }
        debugPrint("result..... $listOfObject");
        Future.delayed(const Duration(seconds: 1), () async {
          var ingredientsListFromFile = await readLabelsFromAsset();
          // debugPrint("File data $ingredientsListFromFile");
          debugPrint("detect $listOfObject");
          var list = filterIngredients(ingredientsListFromFile);
          // debugPrint("Final $list");
          if (list.isNotEmpty) {
            ingredientNotFound.value = false;
          } else {
            ingredientNotFound.value = true;
          }
          CustomLoader().hideLoader();
        });
      }
      else{
        CustomLoader().hideLoader();
      }
    } catch (e) {
      CustomLoader().hideLoader();
      debugPrint("Error $e");
    }
  }

  void loadModel() async {
    var response = await Tflite.loadModel(
        model: 'assets/model/model.tflite',
        labels: 'assets/model/label.txt',
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false);
    debugPrint("Loading model $response");
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

  List<String> filterIngredients(List<String> ingredientsListFromFile) {
    return ingredientsList.value = listOfObject.where((item) {
      return ingredientsListFromFile.contains(item);
    }).toList();
  }
}
