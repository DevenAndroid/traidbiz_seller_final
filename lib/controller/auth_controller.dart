import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as _dio;
import 'package:get/get.dart';
import 'package:traidbiz_seller/data/local/auth_db.dart';
import 'package:traidbiz_seller/data/remote/api_service.dart';
import 'package:traidbiz_seller/globals/globals.dart';
import 'package:traidbiz_seller/screens/splash.dart';
import 'package:traidbiz_seller/screens/wrapper.dart';

import '../constraints/api_endpoints.dart';
import '../data/models/user/user.dart';

class AuthController extends GetxController {
  final _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // form keys
  final GlobalKey<FormState> authFormKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _authCookie = const AuthCookie().obs;
  AuthCookie? get authCookie => _authCookie.value;

  final _isPasswordVisible = false.obs;
  bool get isPasswordVisible => _isPasswordVisible.value;
  void setIsPasswordVisible() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _isLoggedIn.value = AuthDb.isUserLoggedIn();
    final _cookie = AuthDb.getAuthCookie();
    if (_cookie != null) {
      _authCookie.value = _cookie;
    }
  }

  void updateProfile() {
    final _cookie = AuthDb.getAuthCookie();
    if (_cookie != null) {
      _authCookie.value = _cookie;
    }
  }

  Future<bool> login(String username, String password) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcmToken' + fcmToken.toString());
    final client = _dio.Dio();
    debugPrint(":: Login In ::");
    try {
      _isLoading.value = true;
      update();

      final _response = await ApiService.post(
        generateAuthCookie,
        client,
        body: {
          "username": username,
          "password": password,
        },
      );
      log("$_response");

      if (_response['status'] != 'error') {
        final authCookie = AuthCookie.fromJson(_response);
        _setAuthCookie(authCookie);
        return Future.value(true);
      } else {
        Get.snackbar(
          'Oops!',
          _response['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
        return Future.value(false);
      }
    } catch (e) {
      log(e.toString());
      return Future.value(false);
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  void _setAuthCookie(AuthCookie authCookie) {
    AuthDb.setAuthCookie(authCookie);
    _authCookie.value = authCookie;

    if (authCookie.cookie != null) {
      _isLoggedIn.value = true;
    } else {
      _isLoggedIn.value = false;
    }

    update();
  }

  void logout() {
    AuthDb.clearDb();
    _isLoggedIn.value = false;
    Get.offAll(const Splash(), binding: GlobalBindings());
    update();
  }
}
