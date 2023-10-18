import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../utils/Utils.dart';

class ForceUpdatePassword extends StatelessWidget {
  const ForceUpdatePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
        body: ScreenOne(),
      ),
    );
  }
}

class ScreenOne extends StatefulWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Text(
                  'You have\nsuccessfully logged in.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(
                        0xFF5A972A,
                      ),
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
              Image.asset(
                'assets/images/school.png',
                fit: BoxFit.fitWidth,
              )
            ],
          ),
          Utils.sizedBoxHeight(16),
          const Text(
            'Welcome,Jhon Doe',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(
                  0xFF222447,
                ),
                fontWeight: FontWeight.w700,
                fontSize: 24),
          ),
          Utils.sizedBoxHeight(16),
          const Text(
            'let\'s start by updating your contact details.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          ),
          const Text(
            'Please enter your 10 digit mobile number.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.headlineMedium,
              cursorHeight: 28,
              cursorWidth: 1.0,
              // validator: (String value) => mobileNumberValidator(value),
              // controller: phoneController,
              decoration: InputDecoration(
                  labelText: 'Enter Mobile Number',
                  hintText: 'Enter Mobile Number',
                  prefixIcon: const Icon(Icons.phone),
                  labelStyle: Theme.of(context).textTheme.headlineSmall,
                  errorStyle: TextStyle(
                      color: Colors.red, fontSize: ScreenUtil().setSp(12)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  color: Colors.transparent,
                ),
                CircularPercentIndicator(
                  animation: true,
                  animationDuration: 500,
                  radius: 40,
                  lineWidth: 6,
                  percent: 0.33,
                  center: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Step',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '1/3',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  progressColor: const Color(0xFF222744),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ScreenTwo()));
                      },
                      icon: const Icon(
                        Icons.navigate_next,
                        color: Color(0xFF222744),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  _ScreenTwoState createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/email.png',
                  fit: BoxFit.fitWidth,
                )
              ],
            ),
            Utils.sizedBoxHeight(16),
            const Text(
              'Thank You!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(
                    0xFF5A972A,
                  ),
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            Utils.sizedBoxHeight(8),
            const Text(
              'Now we need your email address as the\nschool may need to send you emails.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.headlineMedium,
                cursorHeight: 28,
                cursorWidth: 1.0,
                // validator: (String value) => mobileNumberValidator(value),
                // controller: phoneController,
                decoration: InputDecoration(
                    labelText: 'Enter E-mail ID',
                    hintText: 'Enter E-mail ID',
                    prefixIcon: const Icon(Icons.alternate_email_sharp),
                    labelStyle: Theme.of(context).textTheme.headlineSmall,
                    errorStyle: TextStyle(
                        color: Colors.red, fontSize: ScreenUtil().setSp(12)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF222744),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xFF222744),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.navigate_before,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 1000,
                    radius: 40,
                    lineWidth: 6,
                    percent: 0.67,
                    center: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Step',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '2/3',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    progressColor: const Color(0xFF222744),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScreenThree()));
                        },
                        icon: const Icon(
                          Icons.navigate_next,
                          color: Color(0xFF222744),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenThree extends StatefulWidget {
  const ScreenThree({Key? key}) : super(key: key);

  @override
  _ScreenThreeState createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/password.png',
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Utils.sizedBoxHeight(48),
                        const Text(
                          'Now at last',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(
                                0xFF5A972A,
                              ),
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        Utils.sizedBoxHeight(8),
                        const Text(
                          'For data security and privacy reasons,\nWe suggest you choose your\nown 6 digit passcode',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                        ),
                      ],
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.headlineMedium,
                cursorHeight: 28,
                cursorWidth: 1.0,
                // validator: (String value) => mobileNumberValidator(value),
                // controller: phoneController,
                decoration: InputDecoration(
                    labelText: 'Enter Old Password',
                    hintText: 'Enter Old Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.visibility)),
                    labelStyle: Theme.of(context).textTheme.headlineSmall,
                    errorStyle: TextStyle(
                        color: Colors.red, fontSize: ScreenUtil().setSp(12)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.headlineMedium,
                cursorHeight: 28,
                cursorWidth: 1.0,
                // validator: (String value) => mobileNumberValidator(value),
                // controller: phoneController,
                decoration: InputDecoration(
                    labelText: 'Enter New Password',
                    hintText: 'Enter New Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.visibility)),
                    labelStyle: Theme.of(context).textTheme.headlineSmall,
                    errorStyle: TextStyle(
                        color: Colors.red, fontSize: ScreenUtil().setSp(12)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.headlineMedium,
                cursorHeight: 28,
                cursorWidth: 1.0,
                // validator: (String value) => mobileNumberValidator(value),
                // controller: phoneController,
                decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    hintText: 'Confirm New Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.visibility)),
                    labelStyle: Theme.of(context).textTheme.headlineSmall,
                    errorStyle: TextStyle(
                        color: Colors.red, fontSize: ScreenUtil().setSp(12)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF222744),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xFF222744),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.navigate_before,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 1500,
                    radius: 40,
                    lineWidth: 6,
                    percent: 1,
                    center: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Step',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '3/3',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    progressColor: const Color(0xFF222744),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScreenThree()));*/
                        },
                        icon: const Icon(
                          Icons.navigate_next,
                          color: Color(0xFF222744),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class ScreenOne extends StatefulWidget {
  const ScreenOne({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

TextEditingController phoneController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController oldPasswordController = TextEditingController();
TextEditingController newPasswordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
TextEditingController _oldPinController = TextEditingController();


class _BodyState extends State<ScreenOne> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation _colorTween;
  FocusNode _focusNode = FocusNode();
  FocusNode _newfocusNode = FocusNode();
  FocusNode _confirmfocusNode = FocusNode();
  bool hidePIN = true;
  bool hideNewPIN = true;
  bool hideConfirmPIN = true;
  bool validatePIN = false;
  bool isResponse = false;

  @override
  void initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..repeat(reverse: true);
    _colorTween = ColorTween(begin: Colors.blue[700], end: Colors.white)
        .animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Trying to login for the first time?',textAlign: TextAlign.left,style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),),
          ), Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Please change the password as you login for the first time for your account safety.',style: TextStyle(
              fontWeight: FontWeight.bold,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.headlineMedium,
              cursorHeight: 28,
              cursorWidth: 1.0,
              validator: (String value) => mobileNumberValidator(value),
              controller: phoneController,
              decoration: InputDecoration(
                  labelText: "Enter Mobile Number",
                  hintText: "Enter Mobile Number",
                  suffixIcon: const Icon(Icons.phone),
                  labelStyle: Theme.of(context).textTheme.headlineSmall,
                  errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: ScreenUtil().setSp(12)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.headlineMedium,
              cursorHeight: 28,
              cursorWidth: 1.0,
              validator: (String value) => emailAddressValidator(value),
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Enter E-mail Address",
                  hintText: "Enter E-mail Address",
                  suffixIcon: const Icon(Icons.alternate_email),
                  labelStyle: Theme.of(context).textTheme.headlineSmall,
                  errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: ScreenUtil().setSp(12)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Divider(
                      thickness: 1,
                    )),
                Utils.sizedBoxWidth(8),
              Text('Enter Old Password',style: Theme.of(context).textTheme.headlineSmall,),
                Utils.sizedBoxWidth(8),
                Expanded(
                    flex: 8,
                    child: Divider(
                      thickness: 1,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _colorTween,
                    builder: (context, child) {
                      return Pinput(
                        focusNode: _focusNode,
                        obscureText: hidePIN,
                        controller: _oldPinController,
                        length: 6,
                        closeKeyboardWhenCompleted: true,
                        pinAnimationType: PinAnimationType.scale,
                        focusedPinTheme:
                        defaultPinTheme.copyDecorationWith(
                          border: Border.all(
                              color: _colorTween.value, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        showCursor: true,
                        autofocus: true,
                        defaultPinTheme: PinTheme(
                          textStyle: TextStyle(
                              fontSize: hidePIN ? 30 : 19),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey[400],
                              width: 1,
                            ),
                          ),
                        ),
                        onChanged: (value) {},
                        onCompleted: (value) {
                          setState(() {
                            validatePIN = true;
                          });
                        },
                      );
                    },
                  ),
                ),
                Utils.sizedBoxWidth(8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey[400],
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        hidePIN
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Color(0xFF222744),
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePIN = !hidePIN;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Divider(
                      thickness: 1,
                    )),
                Utils.sizedBoxWidth(8),
              Text('Enter New Password',style: Theme.of(context).textTheme.headlineSmall,),
                Utils.sizedBoxWidth(8),
                Expanded(
                    flex: 8,
                    child: Divider(
                      thickness: 1,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _colorTween,
                    builder: (context, child) {
                      return Pinput(
                        focusNode: _newfocusNode,
                        obscureText: hideNewPIN,
                        controller: newPasswordController,
                        length: 6,
                        closeKeyboardWhenCompleted: true,
                        pinAnimationType: PinAnimationType.scale,
                        focusedPinTheme:
                        defaultPinTheme.copyDecorationWith(
                          border: Border.all(
                              color: _colorTween.value, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        showCursor: true,
                        autofocus: true,
                        defaultPinTheme: PinTheme(
                          textStyle: TextStyle(
                              fontSize: hideNewPIN ? 30 : 19),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey[400],
                              width: 1,
                            ),
                          ),
                        ),
                        onChanged: (value) {},
                        onCompleted: (value) {
                          setState(() {
                            validatePIN = true;
                          });
                        },
                      );
                    },
                  ),
                ),
                Utils.sizedBoxWidth(8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey[400],
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        hideNewPIN
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Color(0xFF222744),
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          hideNewPIN = !hideNewPIN;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Divider(
                      thickness: 1,
                    )),
                Utils.sizedBoxWidth(8),
              Text('Confirm New Password',style: Theme.of(context).textTheme.headlineSmall,),
                Utils.sizedBoxWidth(8),
                Expanded(
                    flex: 8,
                    child: Divider(
                      thickness: 1,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _colorTween,
                    builder: (context, child) {
                      return Pinput(
                        focusNode: _confirmfocusNode,
                        obscureText: hideConfirmPIN,
                        controller: confirmPasswordController,
                        length: 6,
                        closeKeyboardWhenCompleted: true,
                        pinAnimationType: PinAnimationType.scale,
                        focusedPinTheme:
                        defaultPinTheme.copyDecorationWith(
                          border: Border.all(
                              color: _colorTween.value, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        showCursor: true,
                        autofocus: true,
                        defaultPinTheme: PinTheme(
                          textStyle: TextStyle(
                              fontSize: hideConfirmPIN ? 30 : 19),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey[400],
                              width: 1,
                            ),
                          ),
                        ),
                        onChanged: (value) {},
                        onCompleted: (value) {
                          setState(() {
                            validatePIN = true;
                          });
                        },
                      );
                    },
                  ),
                ),
                Utils.sizedBoxWidth(8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey[400],
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        hideConfirmPIN
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Color(0xFF222744),
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          hideConfirmPIN = !hideConfirmPIN;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        decoration: Utils.BtnDecoration,
                        child: Text(
                          "Update",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () async {

                    }),
                isResponse == true
                    ? LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                )
                    : Text(''),
              ],
            ),
          )
        ],
      ),
    );
  }

  String mobileNumberValidator(String value){

  }

  String emailAddressValidator(String value){

  }

  final defaultPinTheme = PinTheme(
    height: 60,
    width: 40,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

}*/

/*class StepperBody extends StatefulWidget {
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;
  static var _focusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static MyData data = MyData();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  void dispose() {
    // _focusNode.dispose();
    super.dispose();
  }

  List<Step> steps = [
    Step(
        title: const Text('Phone'),
        //subtitle: const Text('Subtitle'),
        isActive: true,
        //state: StepState.editing,
        state: StepState.indexed,
        content: Form(
          key: formKeys[1],
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.phone,
                autocorrect: false,
                validator: (value) {
                  if (value.isEmpty || value.length < 10) {
                    return 'Please enter valid number';
                  } else
                    return "";
                },
                onSaved: (String value) {
                  data.phone = value;
                },
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Enter your number',
                    hintText: 'Enter a number',
                    icon: const Icon(Icons.phone),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('E-mail'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        // state: StepState.disabled,
        content: Form(
          key: formKeys[2],
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Please enter valid email';
                  } else
                    return "";
                },
                onSaved: (String value) {
                  data.email = value;
                },
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Enter your email',
                    hintText: 'Enter a email address',
                    icon: const Icon(Icons.email),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Password'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: Form(
          key: formKeys[0],
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  onSaved: (String value) {
                    data.name = value;
                  },
                  maxLines: 1,
                  validator: (value) {
                    if (value.isEmpty || value.length < 1) {
                      return "Please enter password";
                    } else if (value.length < 6) {
                      return "Please enter password of Six digits.";
                    } else
                      return "";
                  },
                  decoration: InputDecoration(
                      labelText: "Enter Password",
                      hintText: "Enter Password",
                      suffixIcon: const Icon(Icons.password),
                      labelStyle:
                          TextStyle(decorationStyle: TextDecorationStyle.solid,fontSize: 14),
                      errorStyle: TextStyle(
                          color: Colors.red, fontSize: ScreenUtil().setSp(12)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
            ],
          ),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

    void _submitDetails() {
      final FormState formState = _formKey.currentState;

      if (!formState.validate()) {
        showSnackBarMessage('Please enter correct data');
      } else {
        formState.save();
        print("Name: ${data.name}");
        print("Phone: ${data.phone}");
        print("E-mail: ${data.email}");

        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text("Details"),
                  //content:  Text("Hello World"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text("Name : " + data.name),
                        Text("Phone : " + data.phone),
                        Text("E-mail : " + data.email),
                        Text("Age : " + data.age),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      }
    }

    return Container(
        child: Form(
      key: _formKey,
      child: ListView(children: <Widget>[
        Stepper(
          steps: steps,
          type: StepperType.vertical,
          currentStep: this.currStep,
          onStepContinue: () {
            setState(() {
              if (formKeys[currStep].currentState.validate()) {
                if (currStep < steps.length - 1) {
                  currStep = currStep + 1;
                } else {
                  currStep = 0;
                }
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currStep > 0) {
                currStep = currStep - 1;
              } else {
                currStep = 0;
              }
            });
          },
          onStepTapped: (step) {
            setState(() {
              currStep = step;
            });
          },
        ),
        RaisedButton(
          child: Text(
            'Save details',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: _submitDetails,
          color: Colors.blue,
        ),
      ]),
    ));
  }

  Widget appBar() => Container(
        height: 70,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF222744),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Text(
                            'Update Password',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                .copyWith(
                                    fontSize: ScreenUtil().setSp(20),
                                    color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            );
          },
        ),
      );
}

class MyData {
  String name = '';
  String phone = '';
  String email = '';
  String age = '';
}*/
