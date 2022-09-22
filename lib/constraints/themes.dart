import 'package:flutter/material.dart';
import 'package:traidbiz_seller/constraints/colors.dart';

ThemeData theme() => ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFFf3f7fa),
      backgroundColor: const Color(0xFFf3f7fa),
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: Colors.black),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFf3f7fa),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton?.styleFrom(
          primary: colorPrimary,
        ),
      ),
    );

ThemeData darkTheme() => ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.amber,
      scaffoldBackgroundColor: const Color(0xFF121212),
      backgroundColor: Colors.black,
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: Colors.white),
      ),
    );
