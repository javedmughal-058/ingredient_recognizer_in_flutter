import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ingredient_recognizer_in_flutter/controller/base_controller.dart';
import 'package:ingredient_recognizer_in_flutter/utils/constant/helper.dart';
import 'package:ingredient_recognizer_in_flutter/utils/custom_widgets/button_widget.dart';
import 'package:ingredient_recognizer_in_flutter/utils/custom_widgets/card_button.dart';
import 'package:ingredient_recognizer_in_flutter/utils/custom_widgets/custom_textField.dart';
import 'package:ingredient_recognizer_in_flutter/utils/custom_widgets/positioned_widget.dart';
import 'package:ingredient_recognizer_in_flutter/utils/loader/custom_loader.dart';
import 'package:ingredient_recognizer_in_flutter/view/widgets/image_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BaseController baseController = Get.find();
  late CustomLoader loader;

  @override
  void initState() {
    super.initState();
    loader = CustomLoader();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final commonSize = SizedBox(height: size.height * 0.02);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            alignment: Alignment.topRight,
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(Helper.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select image to find Ingredients',
                        style: Theme.of(context).textTheme.titleLarge),
                    commonSize,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomCardButton(
                            radius: 12,
                            width: size.width * 0.15,
                            height: size.width * 0.15,
                            bgColor: Theme.of(context).cardColor,
                            icon: Icons.camera_alt_outlined,
                            onTap: () {
                              baseController.getPhoto(
                                  context, ImageSource.camera);
                            }),
                        CustomCardButton(
                            radius: 12,
                            width: size.width * 0.15,
                            height: size.width * 0.15,
                            bgColor: Theme.of(context).secondaryHeaderColor,
                            icon: Icons.photo_camera_back_outlined,
                            onTap: () {
                              baseController.getPhoto(
                                  context, ImageSource.gallery);
                            }),
                      ],
                    ),
                    commonSize,
                    buildImageCard(context,
                        controller: baseController, size: size),
                    commonSize,
                    Obx(() => ButtonWidget(
                        onTap: () {
                          if (baseController.image.value != null) {
                            loader.showLoader(context);
                            baseController
                                .processingOnImage(context)
                                .then((_) async {
                              loader.hideLoader();
                            });
                          }
                          else {
                            Helper.showErrorAlert(context,
                                msg: "Select Image First");
                          }
                        },
                        icon: Icons.document_scanner_outlined,
                        title: 'Proceed Next',
                        size: size,
                        bgColor: baseController.image.value == null
                            ? Colors.grey.shade300
                            : null)),

                    Obx(() => baseController.recognizeText.value == ""
                        ? const SizedBox()
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonSize,
                            Text('Recognized Ingredients', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 5),
                            CustomTextField(
                              onChanged: (value){
                                baseController.isFinalButtonShow.value = true;
                                baseController.finalResult.value = "";
                              },
                              innerTextStyle: Theme.of(context).textTheme.bodySmall,
                              borderColor: Theme.of(context).cardColor,
                              fillColor: Theme.of(context).secondaryHeaderColor,
                              isFilled: true,
                              controller: baseController.textController,
                              textInputType: TextInputType.text, isReadOnly: false),
                          ],
                        )),

                    Obx(() => Text(baseController.errorMessage.value,
                        style: Theme.of(context).textTheme.bodyMedium)),
                    Obx(() => baseController.isFinalButtonShow.value
                        ? ButtonWidget(
                        onTap: () => baseController.makeFinalResult(),
                        icon: Icons.done_all_outlined,
                        title: 'Final Result',
                        size: size)
                        : const SizedBox()),
                    Obx(() => Text(baseController.finalResult.value,
                        style: Theme.of(context).textTheme.titleSmall)),
                  ],
                ),
              ),
              PositionedCircle(
                  radius: size.width * 0.4,
                  topValue: -50,
                  rightValue: -100,
                  color:
                      Theme.of(context).secondaryHeaderColor.withOpacity(0.1)),
              // PositionedCircle(radius: size.width * 0.4,bottomValue: -20, rightValue: -100, color: Theme.of(context).primaryColor.withOpacity(0.1)),
            ],
          ),
        ),
      ),
    );
  }
}
