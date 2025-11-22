import 'package:flutter/material.dart';

const kPrimary = Color(0xFFBC2239); // #BC2239
const kPrimaryDark = Color(0xFF8A1221);
const kBg = Color(0xFFF8F8F8);
const kCard = Colors.white;

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimary,
    primary: kPrimary,
    secondary: kPrimaryDark,
  ),
  scaffoldBackgroundColor: kBg,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: kCard,
    foregroundColor: Colors.black87,
    elevation: 0,
    centerTitle: false,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF1F1F1),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  ),
);
