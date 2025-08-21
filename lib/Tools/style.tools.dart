import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// ignore: camel_case_types
abstract class styleText {
  static const TextStyle loginText = TextStyle(
    fontSize: 20,
  );
  static  TextStyle registerText = TextStyle(
      fontSize: 20,
      color: HexColor('46BBC7'),
      fontFamily: 'Urbanist');

  static const TextStyle EditHeaderText =
      TextStyle(fontSize: 22, color: Colors.white, fontFamily: 'Urbanist');

  static const TextStyle select_button_white =
      TextStyle(color: Colors.white, fontFamily: 'Urbanist');

  static const TextStyle styleNameProfile = TextStyle(
      color: Colors.black,
      fontFamily: 'Urbanist',
      fontSize: 21,
      fontWeight: FontWeight.w500);

  static const TextStyle styleIDProfile =
      TextStyle(color: Colors.black, fontFamily: 'Urbanist', fontSize: 15);

  static TextStyle styleHeaderPlace = TextStyle(
      color: HexColor('000000'),
      fontFamily: 'Urbanist',
      fontSize: 15,
      fontWeight: FontWeight.bold);
}
