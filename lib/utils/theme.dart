// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
        headlineSmall: base.headlineSmall!.copyWith(
          fontSize: ScreenUtil().setSp(16.0),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF222744),
        ),
        titleMedium: base.titleMedium!.copyWith(
          fontSize: ScreenUtil().setSp(16.0),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF222744),
        ),
        titleSmall: base.titleMedium!.copyWith(
            fontSize: ScreenUtil().setSp(14.0),
            fontWeight: FontWeight.w500,
            color: Colors.black),
        titleLarge: base.titleLarge!.copyWith(
          fontSize: ScreenUtil().setSp(12.0),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF222744),
        ),
        headlineMedium: base.headlineSmall!.copyWith(
          fontSize: ScreenUtil().setSp(18.0),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          // color: Color(0xFF727FC8),
        ),
        displaySmall: base.headlineSmall!.copyWith(
          fontSize: ScreenUtil().setSp(22.0),
          color: Colors.grey,
        ),
        bodySmall: base.bodySmall!.copyWith(
          color: const Color(0xFF222744),
        ),
        bodyMedium: base.bodyMedium!.copyWith(color: const Color(0xFF222744)));
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      actionsIconTheme: const IconThemeData(color: Colors.black),
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent),
      titleTextStyle: TextStyle(
        fontSize: ScreenUtil().setSp(16.0),
        fontWeight: FontWeight.w600,
        color: const Color(0xFF222744),
      ),
    ),

    // SystemUiOverlayStyle(statusBarColor: Colors.transparent)),
    textTheme: _basicTextTheme(base.textTheme),
    //textTheme: Typography().white,
    primaryColor: const Color(0xFF222744),
    //primaryColor: Color(0xff4829b2),
    indicatorColor: const Color(0xFF807A6B),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    iconTheme: IconThemeData(
      color: Colors.white,
      size: ScreenUtil().setSp(30.0),
    ),
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: const Color(0xffce107c),
      unselectedLabelColor: Colors.grey,
    ),
    // colorScheme:  ColorScheme(
    //     background: Colors.white, brightness: Brightness.light,primary: Colors.white,onPrimary: Colors.black)
  );
}
