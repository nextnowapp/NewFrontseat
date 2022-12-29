import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nextschool/screens/frontseat/widgets/custom_appbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/widget/textwidget.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String version = '';
  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const TextWidget(
          txt: 'About Us',
          clr: Colors.white,
          size: 20,
          weight: FontWeight.w500,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  child: SvgPicture.asset('assets/frontseat_logo.svg')),
              const SizedBox(
                height: 30,
              ),
              const TextWidget(
                txt: 'WE ARE THE',
                clr: Colors.red,
                size: 20,
                weight: FontWeight.bold,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Center(
                  child: TextWidget(
                    txt: 'INFORMAL MARKET SPECIALIST',
                    clr: Colors.red,
                    weight: FontWeight.bold,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextWidget(
                  txt:
                      'With over 10 years in the signage and branding industry, Frontseat Group continues to grow becoming leaders of signage &\nbranding within the informal market.',
                  size: 17,
                  weight: FontWeight.w400,
                  align: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextWidget(
                  txt:
                      'The team combined bring skills,knowledge and extensive media,marketing and sales experience',
                  size: 17,
                  weight: FontWeight.w400,
                  align: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextWidget(
                  txt:
                      "It is our intentions to further develop skills and impart Knowledge to the pdi's through training and practical experience",
                  size: 17,
                  weight: FontWeight.w400,
                  align: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.65,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      launchUrl(Uri.parse('https://frontseat.co.za/'));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: TextWidget(
                        txt: 'Visit our Website',
                        size: 20,
                        weight: FontWeight.w500,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextWidget(
          txt: 'Version : $version',
          align: TextAlign.center,
          clr: Colors.grey.withOpacity(0.8),
          weight: FontWeight.bold,
        ),
      ),
    );
  }
}
