import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant.dart';

class FontConstant {
  static TextStyle inter = GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      color: AppStyle.textColor,
      fontSize: SizeConstant.font14);

  static TextTheme interTheme = GoogleFonts.interTextTheme();

  static TextStyle interXLBold =
      inter.copyWith(fontSize: 24, fontWeight: FontWeight.bold);

  static TextStyle interLargeBold =
      inter.copyWith(fontWeight: FontWeight.bold, fontSize: 18);

  static TextStyle interMediumBold =
      inter.copyWith(fontWeight: FontWeight.bold, fontSize: 16);

  static TextStyle interSmallBold =
      inter.copyWith(fontWeight: FontWeight.bold, fontSize: 12);

  static TextStyle interXL = inter.copyWith(fontSize: 24);

  static TextStyle interSmall =
      inter.copyWith(fontWeight: FontWeight.normal, fontSize: 12);

  static TextStyle interExtraSmall =
      inter.copyWith(fontWeight: FontWeight.normal, fontSize: 8);

  static TextStyle interExtraSmallBold =
      inter.copyWith(fontWeight: FontWeight.bold, fontSize: 8);

  static TextStyle interMedium =
      inter.copyWith(fontWeight: FontWeight.normal, fontSize: 16);

  static TextStyle interLarge =
      inter.copyWith(fontWeight: FontWeight.normal, fontSize: 18);

  TextStyle headStyle =
      FontConstant.inter.copyWith(fontWeight: FontWeight.bold);
  TextStyle cellStyle =
      FontConstant.inter.copyWith(fontSize: SizeConstant.font12);

  TextStyle drawerHeaderStyle =
      FontConstant.inter.copyWith(fontSize: SizeConstant.font15);

  TextStyle drawerStyle = FontConstant.inter.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: SizeConstant.font15,
      color: Colors.white);

  TextStyle popUpStyle = FontConstant.inter
      .copyWith(fontWeight: FontWeight.w500, fontSize: SizeConstant.font18);
}
