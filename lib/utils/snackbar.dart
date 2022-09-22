import 'package:flutter/material.dart';
import 'package:get/get.dart';

snack(String title, String desc, IconData icon) => Get.snackbar(
      title,
      desc,
      icon: Icon(icon),
      snackPosition: SnackPosition.BOTTOM,
    );
