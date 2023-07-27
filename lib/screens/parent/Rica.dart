import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class RICA extends StatefulWidget {
  @override
  _RICAState createState() => _RICAState();
}

class _RICAState extends State<RICA> {
  late InAppWebViewController _webViewController;
  final URL = 'https://www.cellc.co.za/digital/rica/';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          mediaPlaybackRequiresUserGesture: false, javaScriptEnabled: true),
      ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
          allowsAirPlayForMediaPlayback: true));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'RICA',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
              ).fontFamily,
            ),
          ),
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          Expanded(
              child: Stack(children: [
            InAppWebView(
              // key: webViewKey,
              initialUrlRequest: URLRequest(url: Uri.parse(URL)),
              initialOptions: options,
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              onWebViewCreated: (controller) async {
                _webViewController = controller;
              },
            )
          ]))
        ])));
  }

  // JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  //   return JavascriptChannel(
  //       name: 'Toaster',
  //       onMessageReceived: (JavascriptMessage message) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(message.message)),
  //         );
  //       });
  // }
}

// _launchURL(BuildContext context)  {
//   try {
//      launch(
//       'https://www.cellc.co.za/digital/rica/',
//       customTabsOption: CustomTabsOption(
//         toolbarColor: Theme.of(context).primaryColor,
//         enableDefaultShare: true,
//         enableUrlBarHiding: true,
//         showPageTitle: true,
//         animation: CustomTabsSystemAnimation.slideIn(),
//         // or user defined animation.
//         // animation:  CustomTabsAnimation(
//         //   startEnter: 'slide_up',
//         //   startExit: 'android:anim/fade_out',
//         //   endEnter: 'android:anim/fade_in',
//         //   endExit: 'slide_down',
//         // ),
//         // extraCustomTabs: const <String>[
//         //   // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
//         //   'org.mozilla.firefox',
//         //   // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
//         //   'com.microsoft.emmx',
//         // ],
//       ),
//       safariVCOption: SafariViewControllerOption(
//         preferredBarTintColor: Theme.of(context).primaryColor,
//         preferredControlTintColor: Colors.white,
//         barCollapsingEnabled: true,
//         entersReaderIfAvailable: false,
//         dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
//       ),
//     );
//   } catch (e) {
//     // An exception is thrown if browser app is not installed on Android device.
//     debugPrint(e.toString());
//   }
// }
