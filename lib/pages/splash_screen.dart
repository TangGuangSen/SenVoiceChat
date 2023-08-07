import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/pages/MBottomNavigattionBar.dart';
import 'package:flutter_chatgpt/route.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Values/values.dart';
import '../wedigets/DarkBackground/darkRadialBackground.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(HOME_PAGE);
      // Get.to(() => Timeline());
    });
  }

  final Shader linearGradient = LinearGradient(
    begin: FractionalOffset.topCenter,
    colors: <Color>[AppColors.primaryAccentColorV2, AppColors.primaryAccentColor],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 30.0, 40.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        // Positioned(left: 140, child: AppLogo()),
        Center(
            child: Container(
          child: RichText(
            text: TextSpan(
              text: 'Ai',
              style: GoogleFonts.lato(fontSize: 40),
              children: <TextSpan>[
                TextSpan(
                    text: 'Flow',
                    style: TextStyle(foreground: Paint()..shader = linearGradient, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ))
        // DarkRadialBackground(
        //   color: Colors.transparent,
        //   position: "bottomRight",
        // ),
      ]),
    );
  }
}
