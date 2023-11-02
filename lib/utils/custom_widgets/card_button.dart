import 'package:flutter/material.dart';
import 'package:ingredient_recognizer_in_flutter/utils/constant/helper.dart';

class CustomCardButton extends StatelessWidget {
  final Function() onTap;
  final Color? bgColor;
  final IconData? icon;
  final double? radius;
  final double? height;
  final double? width;
  const CustomCardButton({super.key, required this.onTap,
    this.bgColor, this.icon, this.radius, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
        child: Container(
          height: height ?? size.width * 0.2,
          width:  width ?? size.width * 0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 5),
            color: bgColor ?? Theme.of(context).colorScheme.background,
          ),
          child:icon == null ? const SizedBox():  Icon(icon,color: Colors.white, size: 32),
        ));
  }
}
