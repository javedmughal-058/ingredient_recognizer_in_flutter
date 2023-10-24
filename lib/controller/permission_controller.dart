import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController{


  @override
  void onInit() {
    super.onInit();
    checkCameraPermission().then((value) =>  checkFilePermission());

  }


  Future<void> checkCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
  }
  Future<void> checkFilePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }

}