import 'package:flutter/material.dart';
import 'package:ingredient_recognizer_in_flutter/utils/constant/helper.dart';

class ButtonWidget extends StatelessWidget {
  final Size size;
  final String title;
  final Color? bgColor;
  final IconData? icon;
  final Function()? onTap;
  const ButtonWidget({super.key, required this.size, required this.title, this.bgColor, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.width * 0.13,
        width: size.width,
        padding: EdgeInsets.all(Helper.padding / 4),
        decoration: BoxDecoration(
          color: bgColor ?? Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon == null ? const SizedBox() : Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(title, style: Theme.of(context).textTheme.bodyLarge,),
          ],
        ),
      ),
    );
  }
}
