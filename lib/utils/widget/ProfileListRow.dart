// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Package imports:
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ProfileRowList extends StatelessWidget {
  String _key;
  String? _value;

  ProfileRowList(this._key, this._value);

  @override
  Widget build(BuildContext context) {
    print(_value);
    print(_key);

    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: _value != null
              ? _value!.contains('+') ||
                      (_key.contains('Phone number') ||
                          _key.contains('Phone')) ||
                      _value!.contains('@')
                  ? InkWell(
                      onTap: () async {
                        if ((_key.contains('Phone number'))) {
                          await launchUrl(Uri.parse('tel:$_value'))
                              ? await launchUrl(Uri.parse('tel:$_value'))
                              : throw 'Couldnt laucnh $_value';
                        } else if (_value!.contains('@')) {
                          print(_value);
                          if (!await launchUrl(Uri.parse('mailto:$_value')))
                            throw 'Couldnt laucnh $_value';
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        color: const Color(0xff415094),
                                        fontWeight: FontWeight.normal,
                                        fontSize: ScreenUtil().setSp(14),
                                      ),
                                ),
                                SizedBox(
                                  height: 12.0.h,
                                ),
                                Container(
                                  height: 0.2.h,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xff415094),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _value == null ? 'NA' : _value!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        color: const Color(0xff415094),
                                        fontWeight: FontWeight.normal,
                                        fontSize: ScreenUtil().setSp(14),
                                      ),
                                ),
                                SizedBox(
                                  height: 12.0.h,
                                ),
                                Container(
                                  height: 0.2.h,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff415094),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _key == 'Present address'
                                    ? 'Current Address'
                                    : _key,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                      color: const Color(0xff415094),
                                      fontWeight: FontWeight.normal,
                                      fontSize: ScreenUtil().setSp(14),
                                    ),
                              ),
                              SizedBox(
                                height: 12.0.h,
                              ),
                              Container(
                                height: 0.2.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xff415094),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _value == null ? 'NA' : _value!,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                      color: const Color(0xff415094),
                                      fontWeight: FontWeight.normal,
                                      fontSize: ScreenUtil().setSp(14),
                                    ),
                              ),
                              SizedBox(
                                height: 12.0.h,
                              ),
                              Container(
                                height: 0.2.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xff415094),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
              : Container()),
    );
  }
}
