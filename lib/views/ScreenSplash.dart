import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musica/controllers/screen_splash_controller.dart';
import 'package:musica/models/songs.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/views/ScreenNavigation.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}




class _SplashScreenState extends State<SplashScreen> {

 

  @override
  void initState() {

   
   // requestPermission();
 // gotoscreen(context);
  Get.put(ScreenSpashController());
//  Get.find<ScreenSpashController>();
  

    

    // TODO: implement initState
   
    super.initState();
  }

  // Future<void> requestPermission() async {
  //  // setState(() async {

  //     await Permission.storage.request();

  // //  }
  //   //);
  //   //await Permission.audio.request();
  // }

 

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: kBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 0.2 * screenHeight,
                  width: 0.6 * screenWidth,
                  child: Image.asset('assets/images/logo.png')),
              SizedBox(
                height: 0.03 * screenHeight,
              ),
              Text(
                'MUSICA',
                style: TextStyle(color: kWhite, fontSize: 19 * textScale),
              ),
              SizedBox(height: 0.05 * screenHeight),
              const CircularProgressIndicator(
                color: kWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
