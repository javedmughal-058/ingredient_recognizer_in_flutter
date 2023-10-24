import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredient_recognizer_in_flutter/controller/base_controller.dart';

Widget buildImageCard(context,
    {required BaseController controller, required Size size}) {
  return Center(
      child: Obx(() => controller.image.value == null
          ? Text('No Image Selected', style: Theme.of(context).textTheme.bodyMedium)
          : GestureDetector(
            onTap: ()=> controller.cropImage(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                child: Image.file(controller.image.value!,
                    // height: size.height * 0.25,
                    width: size.width,
                    fit: BoxFit.cover),
              ),
            ),
          ),
      ));
}