import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredient_recognizer_in_flutter/controller/base_controller.dart';

final BaseController baseController = Get.find();
class CustomLoader {
  static CustomLoader? _progressLoader;

  CustomLoader._createObject();

  factory CustomLoader() {
    if (_progressLoader != null) {
      return _progressLoader!;
    } else {
      _progressLoader = CustomLoader._createObject();
      return _progressLoader!;
    }
  }

//static OverlayEntry _overlayEntry;
  late OverlayState _overlayState; //= new OverlayState();
  late OverlayEntry _overlayEntry;

  _buildLoader() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: buildLoader(context));
      },
    );
  }

  showLoader(context) {
    _overlayState = Overlay.of(context)!;
    _buildLoader();
    _overlayState.insert(_overlayEntry);
  }

  hideLoader() {
    try {
      _overlayEntry.remove();
      // ignore: null_check_always_fails
      _overlayEntry = null!;
    } catch (e) {
      debugPrint("Exception:: $e");
    }
  }

  buildLoader(BuildContext context, {Color? backgroundColor}) {
    backgroundColor ??= const Color(0xff4d4949).withOpacity(.5);
    var height = 150.0;
    return CustomScreenLoader(
      height: height,
      width: height,
      backgroundColor: backgroundColor,
      // label: label,

    );
  }
}

class CustomScreenLoader extends StatelessWidget {
  final Color backgroundColor;
  final double height;
  final double width;
  // final String? label;
  const CustomScreenLoader(
      {Key? key,
        this.backgroundColor = const Color(0xff24577a),
        this.height = 30,
        this.width = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: backgroundColor,
        child: Container(
          height: height,
          width: height,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(()=> Text(baseController.loadingMsg.value, style: Theme.of(context).textTheme.titleSmall)),
                const SizedBox(height: 20.0),
                CircularProgressIndicator(backgroundColor: Theme.of(context).secondaryHeaderColor, color: Colors.white)
              ],
            ),
          ),
        ),
      ),
    );
  }
}