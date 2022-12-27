import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:traidbiz_seller/constraints/colors.dart';
import 'package:traidbiz_seller/data/local/intro_db.dart';
import '/screens/intro/intro.dart';
import 'package:traidbiz_seller/constraints/images.dart';

import '/constraints/images.dart';
import '../screens/wrapper.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    if (SchedulerBinding.instance != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        debugPrint("First Time? :${IntroDb.isFirstTimeOpen()}");
        final _screen =
            IntroDb.isFirstTimeOpen() ? const IntroScreen() : const Wrapper();

        if (timeStamp.inSeconds < 3) {
          Future.delayed(Duration(seconds: 3 - timeStamp.inSeconds)).then((_) {
            Get.off(() => _screen);
          });
        } else {
          Get.off(() => _screen);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(splashIcon,fit: BoxFit.cover,),
      ),
    );
  }
}
