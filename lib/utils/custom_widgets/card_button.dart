import 'package:flutter/material.dart';
import 'package:ingredient_recognizer_in_flutter/utils/constant/helper.dart';

class CustomCardButton extends StatelessWidget {
  final Function() onTap;
  final Color? bgColor;
  final String title;
  final IconData? icon;
  final double? radius;
  final double? height;
  final double? width;
  const CustomCardButton({super.key, required this.onTap,
    this.bgColor, this.icon, this.radius, this.height, this.width, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: onTap,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: height ?? size.width * 0.2,
              width:  width ?? size.width * 0.2,
              margin: const EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(horizontal: Helper.padding / 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius ?? 5),
                color: bgColor ?? Theme.of(context).colorScheme.background,
              ),
              child:icon == null ? const SizedBox():  Icon(icon,color: Colors.white, size: 32),
            ),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
          ],
        ));
  }
}
