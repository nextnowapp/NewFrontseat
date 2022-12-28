// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
        headline5: base.headline5!.copyWith(
          fontSize: ScreenUtil().setSp(16.0),
          fontWeight: FontWeight.w600,
          color: const Color(0xFF222744),
        ),
        subtitle1: base.subtitle1!.copyWith(
          fontSize: ScreenUtil().setSp(16.0),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF222744),
        ),
        subtitle2: base.subtitle1!.copyWith(
            fontSize: ScreenUtil().setSp(14.0),
            fontWeight: FontWeight.w500,
            color: Colors.black),
        headline6: base.headline6!.copyWith(
          fontSize: ScreenUtil().setSp(12.0),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF222744),
        ),
        headline4: base.headline5!.copyWith(
          fontSize: ScreenUtil().setSp(18.0),
          fontWeight: FontWeight.w600,
          color: Colors.black,
          // color: Color(0xFF727FC8),
        ),
        headline3: base.headline5!.copyWith(
          fontSize: ScreenUtil().setSp(22.0),
          color: Colors.grey,
        ),
        caption: base.caption!.copyWith(
          color: const Color(0xFF222744),
        ),
        bodyText2: base.bodyText2!.copyWith(color: const Color(0xFF222744)));
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
      backgroundColor: Colors.white,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: const Color(0xffce107c),
        unselectedLabelColor: Colors.grey,
      ));
}
