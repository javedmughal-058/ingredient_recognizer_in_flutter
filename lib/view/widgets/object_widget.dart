import 'package:flutter/material.dart';
import 'package:ingredient_recognizer_in_flutter/utils/constant/helper.dart';

Widget buildObjectWidget(context, {required String title}){
  return Container(
      margin: EdgeInsets.all(Helper.margin / 4),
      padding: EdgeInsets.all(Helper.padding / 4),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(title,textAlign: TextAlign.start, style: const TextStyle(color: Colors.white, fontSize: 14)));
}