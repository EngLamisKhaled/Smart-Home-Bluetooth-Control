import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import 'auth_screens/signin_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset("assets/images/logo2.png"),
      //logoWidth: 250,
      durationInSeconds: 5,
      backgroundColor: Colors.white,
      showLoader: true,
      loaderColor: Color(0xFF2F55D4),
      navigator: SigninScreen(),
    );
  }
}
