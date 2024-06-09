import 'package:flutter/material.dart';

const Color bluePrimary = Color.fromARGB(255, 0, 77, 168);
const Color white = Colors.white;
const Color offWhite = Color(0xFFFBFBFB);
const Color grey = Color(0xFFF7F7F7);
const Color lightGrey = Color(0xFFE5E5E5);
const Color dividerColor = Color(0xFFD8D8D8);
const Color darkGrey = Color(0xFF6E6E6E);
const Color colorStatusSand = Color.fromARGB(255, 126, 118, 110);
const Color graphite = Color(0xFF3D3D3D);
const Color black = Colors.black;
const Color colorStatusRed = Color.fromARGB(255, 195, 0, 20);

const double defaultSidePadding = 13;

const double fontSizeTitle = 24.0;
const double fontSizeSubtitle = 20.0;
const double fontSizeText = 16.0;

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

OutlineInputBorder multilineErrorTextFieldBorder = multilineTextFieldBorder.copyWith(
  borderSide: const BorderSide(color: Colors.red),
);
