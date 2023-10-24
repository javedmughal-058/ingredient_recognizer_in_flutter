import 'dart:developer';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ingredient_recognizer_in_flutter/controller/base_controller.dart';
import 'package:ingredient_recognizer_in_flutter/view/screens/home_page.dart';
import 'package:ingredient_recognizer_in_flutter/view/screens/profile_page.dart';
class BottomBar extends StatefulWidget {
  const BottomBar({Key? key,}) : super(key: key);


  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  bool circleButtonToggle = false;
  final BaseController baseController = Get.find();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return WillPopScope(
      onWillPop: ()async{
        return await showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                content: const Text("Are you sure to exit"),
                actions: [
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context,true);
                      },
                      child:const Text("Exit")
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child:const Text("Cancel")
                  ),
                ],
              );
            }
        );
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: Obx(()=> IndexedStack(
            index: baseController.currentIndex.value,
            children: const[
              MyHomePage(),
              ProfilePage(),
            ],
          )),
          floatingActionButton: const SizedBox(
            height: 50,
            width: 50,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            barColor: Colors.white,
            controller: FloatingBottomBarController(initialIndex: baseController.currentIndex.value),
            bottomBar: [
              BottomBarItem(
                icon: Icon(Icons.home_outlined, color: const Color(0xff9E9E9E), size: size.width * 0.08),
                iconSelected: Icon(Icons.home_outlined, color: Theme.of(context).cardColor, size: size.width * 0.08),
                title: 'Home',
                titleStyle: Theme.of(context).textTheme.bodySmall,
                dotColor: Theme.of(context).cardColor,
                onTap: (value) {
                  baseController.currentIndex.value = value;
                  log('Home $value');
                },
              ),
              BottomBarItem(
                icon: Icon(Icons.person_2_outlined, color: const Color(0xff9E9E9E), size: size.width * 0.08),
                iconSelected: Icon(Icons.person_2_outlined, color: Theme.of(context).cardColor, size: size.width * 0.08),
                title: 'Profile',
                titleStyle: Theme.of(context).textTheme.bodySmall,
                dotColor: Theme.of(context).cardColor,
                onTap: (value) {
                  baseController.currentIndex.value = value;
                  log('Profile $value');
                },
              ),
            ],
            bottomBarCenterModel: BottomBarCenterModel(
              centerBackgroundColor: Theme.of(context).secondaryHeaderColor,
              centerIcon: FloatingCenterButton(
                child: GestureDetector(
                  onTap: () => baseController.getPhoto(context, ImageSource.camera),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                    ),
                  ),
                ),
              ),
              centerIconChild: [],
            ),
          ),
        ),
      ),
    );
  }
}
