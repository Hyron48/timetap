import 'package:flutter/material.dart';

const Color bluePrimary = Color.fromARGB(255, 0, 77, 168);
const Color backgroundColor = Color.fromARGB(255, 246, 248, 252);
const Color backgroundDarkColor = Color.fromARGB(255, 209, 226, 255);
const Color white = Colors.white;
const Color offWhite = Color(0xFFFBFBFB);
const Color lightGrey = Color(0xFFD5D5D5);
const Color darkGrey = Color(0xFF6E6E6E);
const Color black = Colors.black;
const Color colorStatusRed = Color.fromARGB(255, 195, 0, 20);

const double defaultSidePadding = 13;

const double fontSizeTitle = 24.0;
const double fontSizeSubtitle = 20.0;
const double fontSizeText = 16.0;
const double smallestFontSize = 14.0;

const FontWeight lightFontWeight = FontWeight.w300;
const FontWeight mediumFontWeight = FontWeight.w500;
const FontWeight boldFontWeight = FontWeight.w700;
const FontWeight boldestFontWeight = FontWeight.w900;


const OutlineInputBorder textFieldBorder = OutlineInputBorder(
  borderSide: BorderSide(
      color: lightGrey,
      width: 1.0
  ),
  borderRadius: BorderRadius.all(
      Radius.circular(15.0)
  ),
);

OutlineInputBorder textFieldBorderError = textFieldBorder.copyWith(
  borderSide: const BorderSide(color: Colors.red),
);

OutlineInputBorder multilineTextFieldBorder = textFieldBorder.copyWith(
  borderRadius: const BorderRadius.all(
      Radius.circular(15.0)
  ),
);
