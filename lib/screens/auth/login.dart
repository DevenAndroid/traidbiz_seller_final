import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:traidbiz_seller/constraints/colors.dart';
import 'package:traidbiz_seller/controller/auth_controller.dart';
import 'package:traidbiz_seller/screens/auth/reset_password.dart';

import '../../constraints/images.dart';
import '../../constraints/styles.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: controller.isLoading,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: controller.authFormKey,
            child: Stack(
              children: [
                Positioned(
                    right: 0,
                    left: 0,
                    child: Image.asset("assets/images/login_BGNew.png")),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xff054cfe),
                          ),
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -70,
                                right: 0,
                                left: 0,
                                child: Center(
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: ClipOval(
                                      child: Image.asset('assets/app/logonew.png'),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 50),
                                  Text(
                                    'LOG IN',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text('Login to your account',style: TextStyle(color: Colors.white),),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: controller.usernameController,
                                    decoration: inputDecoration.copyWith(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Email',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: const Icon(Icons.email),
                                      errorStyle: const TextStyle(color: Colors.white),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width:1,color: Colors.yellow),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.grey),
                                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                      border: OutlineInputBorder(
                                          borderSide:  BorderSide(
                                              color: Colors.grey, width: 2.0),
                                          borderRadius: BorderRadius.circular(5.0)),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field is required!";
                                      } else if (!GetUtils.isEmail(value)) {
                                        return "Please enter a valid email";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: controller.passwordController,
                                    decoration: inputDecoration.copyWith(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Password',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      prefixIcon: const Icon(Icons.lock),
                                      errorStyle: const TextStyle(color: Colors.white),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width:1,color: Colors.yellow),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.grey),
                                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                      border: OutlineInputBorder(
                                          borderSide:  BorderSide(
                                              color: Colors.grey, width: 2.0),
                                          borderRadius: BorderRadius.circular(5.0)),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          controller.setIsPasswordVisible();
                                        },
                                        icon: Icon(
                                          controller.isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      ),
                                    ),
                                    obscureText: !controller.isPasswordVisible,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field is required!";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () => Get.to(
                                            () => const ResetPasswordScreen(),
                                      ),
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.orange,
                                      ),
                                      child: const Text('LOG IN'),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _login() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcmToken' + fcmToken.toString());
    if (controller.authFormKey.currentState?.validate() == true) {
      controller.authFormKey.currentState?.save();

      final _response = await controller.login(
        controller.usernameController.text,
        controller.passwordController.text,
      );
      debugPrint("Login Result: $_response");
    }
  }
}
