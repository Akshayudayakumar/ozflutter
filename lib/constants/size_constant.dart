import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

abstract class SizeConstant {
  static double screenHeight = Get.mediaQuery.size.height;
  static double screenWidth = Get.mediaQuery.size.width;

  /// Get the height with the percent value of the screen height.
  static double percentHeight(double percentValue) => percentValue.sh;

  /// Get the width with the percent value of the screen width.
  static double percentWidth(double percentValue) => percentValue.sw;

  static double percentToHeight(double percent) =>
      screenHeight * (percent / 100);

  static double percentToWidth(double percent) => screenWidth * (percent / 100);

  /// Font size
  static double font05 = 05.sp;
  static double font06 = 06.sp;
  static double font07 = 07.sp;
  static double font08 = 08.sp;
  static double font09 = 09.sp;
  static double font10 = 10.sp;
  static double font12 = 12.sp;
  static double font14 = 14.sp;
  static double font15 = 15.sp;
  static double font16 = 16.sp;
  static double font18 = 18.sp;
  static double font20 = 20.sp;
  static double font22 = 22.sp;
  static double font24 = 24.sp;
  static double font25 = 25.sp;
  static double font26 = 26.sp;
  static double font28 = 28.sp;
  static double font30 = 30.sp;
  static double font40 = 40.sp;
  static double font48 = 48.sp;
  static double font50 = 50.sp;

  /// Radius
  static double r04 = 4.r;
  static double r05 = 5.r;
  static double r06 = 6.r;
  static double r08 = 8.r;
  static double r10 = 10.r;

  static double h2 = 2.h;
  static double h03 = 3.h;
  static double h04 = 4.h;
  static double h5 = 5.h;
  static double h6 = 6.h;
  static double h7 = 7.h;
  static double h8 = 8.h;
  static double h10 = 10.h;
  static double h11 = 11.h;
  static double h12 = 12.h;
  static double h13 = 13.h;
  static double h14 = 14.h;
  static double h15 = 15.h;
  static double h16 = 16.h;
  static double h17 = 17.h;
  static double h18 = 18.h;
  static double h19 = 19.h;
  static double h20 = 20.h;
  static double h21 = 21.h;
  static double h22 = 22.h;
  static double h25 = 25.h;
  static double h26 = 26.h;
  static double h27 = 27.h;
  static double h29 = 29.h;
  static double h31 = 31.h;
  static double h33 = 33.h;
  static double h34 = 34.h;
  static double h36 = 36.h;
  static double h37 = 37.h;
  static double h39 = 39.h;
  static double h40 = 40.h;
  static double h43 = 43.h;
  static double h45 = 45.h;
  static double h49 = 49.h;
  static double h50 = 50.h;
  static double h54 = 54.h;
  static double h57 = 57.h;
  static double h67 = 67.h;
  static double h70 = 70.h;
  static double h100 = 100.h;
  static double h150 = 150.h;
  static double h152 = 152.h;
  static double h200 = 200.h;
  static double h224 = 224.h;
  static double h291 = 291.h;
  static double h300 = 300.h;

  static double w01 = 1.w;
  static double w02 = 2.w;
  static double w04 = 4.w;
  static double w06 = 6.w;
  static double w07 = 7.w;
  static double w08 = 8.w;
  static double w09 = 9.w;
  static double w10 = 10.w;
  static double w12 = 12.w;
  static double w13 = 13.w;
  static double w14 = 14.w;
  static double w15 = 15.w;
  static double w16 = 16.w;
  static double w18 = 18.w;
  static double w19 = 19.w;
  static double w26 = 26.w;
  static double w28 = 28.w;
  static double w33 = 33.w;
  static double w35 = 35.w;
  static double w36 = 36.w;
  static double w40 = 40.w;
  static double w47 = 47.w;
  static double w48 = 48.w;
  static double w55 = 55.w;
  static double w64 = 64.w;
  static double w68 = 68.w;
  static double w82 = 82.w;
  static double w85 = 85.w;
  static double w86 = 86.w;
  static double w100 = 100.w;
  static double w108 = 108.w;
  static double w116 = 116.w;
  static double w130 = 130.w;
  static double w146 = 146.w;
  static double w180 = 180.w;
  static double w206 = 206.w;
  static double w242 = 242.w;

  static double sp08 = 08.sp;
  static double sp10 = 10.sp;
  static double sp16 = 16.sp;
}
