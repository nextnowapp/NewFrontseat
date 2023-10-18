import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nextschool/utils/constants.dart';

import 'controllers/question_controller.dart';

class ScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());
    print(_qnController.correctAns.toString() +
        _qnController.questions.length.toString());
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset('assets/icons/bg.svg', fit: BoxFit.fill),
          Column(
            children: [
              const Spacer(flex: 3),
              Text(
                'Score',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: kSecondaryColor),
              ),
              const Spacer(),
              Text(
                '${_qnController.correctAns! * 10}/${_qnController.questions.length * 10}',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: kSecondaryColor),
              ),
              const Spacer(flex: 3),
            ],
          )
        ],
      ),
    );
  }
}
