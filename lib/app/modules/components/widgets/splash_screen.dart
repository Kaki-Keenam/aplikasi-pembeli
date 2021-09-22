import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.amber[600],
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/splash.png"),
                  fit: BoxFit.cover
                )
              ),
            ),
            Center(
                child: Container(
              width: Get.width * 0.45,
              height: Get.width * 0.45,
              child: Image.asset("assets/images/logo.png"),
            )),
          ],
        ),
      ),
    );
  }
}
