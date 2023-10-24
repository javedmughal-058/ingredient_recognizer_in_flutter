import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredient_recognizer_in_flutter/utils/constant/helper.dart';
import 'package:ingredient_recognizer_in_flutter/utils/loader/custom_loader.dart';
import 'object_widget.dart';

Widget buildIngredientCard(context) {
  return Obx(()=> baseController.ingredientsList.isNotEmpty
      ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recognized Ingredients', style: Theme.of(context).textTheme.titleMedium),
          Container(
            margin: EdgeInsets.only(top: Helper.margin / 2),
            padding: EdgeInsets.all(Helper.padding / 4),
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: List.generate(baseController.ingredientsList.length, (index){
                return buildObjectWidget(context, title: baseController.ingredientsList[index]);
              }),
            ),
          ),
        ],
      )
      : baseController.ingredientNotFound.value
      ? Text('No Ingredient found', style: Theme.of(context).textTheme.bodyMedium)
      : const SizedBox());
}