import 'package:flutter/material.dart';
import 'package:ingredient_recognizer_in_flutter/utils/constant/helper.dart';

class PositionedCircle extends StatelessWidget {
  final double? topValue;
  final double? rightValue;
  final double? leftValue;
  final double? bottomValue;
  final Color? color;
  final double radius;
  const PositionedCircle({Key? key, this.topValue, this.rightValue,
    this.leftValue, this.bottomValue, this.color, required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topValue, right: rightValue, bottom: bottomValue, left: leftValue,
      child: Container(
        height: radius,
        width: radius,
        padding: EdgeInsets.all(Helper.padding*4),
        decoration: BoxDecoration(
            color: color ?? Theme.of(context).secondaryHeaderColor.withOpacity(0.4),
            shape: BoxShape.circle
        ),
      ),
    );
  }
}
