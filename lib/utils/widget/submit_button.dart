import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

//Possible states of the submit button
enum SubmitStatus {
  active,
  disabled,
  busy,
  error,
  success,
}

//define submitController
abstract class SubmitController implements ChangeNotifier {
  SubmitStatus get submitStatus;
  bool get isBusy;
  bool get isDisabled;
  bool get isError;
  bool get isSuccess;
  bool get isActive;

  void onPressed();
  void openError();
  void openSuccess();
  //setter for submitStatus
  set submitStatus(SubmitStatus value);
}

//defiene simulated submit controller
class SimulatedSubmitController extends SubmitController with ChangeNotifier {
  SimulatedSubmitController({
    SubmitStatus submitStatus = SubmitStatus.active,
    bool isBusy = false,
    bool isDisabled = false,
    bool isError = false,
    bool isSuccess = false,
    bool isActive = false,
    required VoidCallback onOpenError,
    required VoidCallback onOpenSuccess,
     AsyncCallback? onPressed,
    //define setters
  })  : _submitStatus = submitStatus,
        _isBusy = isBusy,
        _isDisabled = isDisabled,
        _isError = isError,
        _isSuccess = isSuccess,
        _onOpenError = onOpenError,
        _onOpenSuccess = onOpenSuccess,
        _onPressed = onPressed!,
        _isActive = isActive;

  SubmitStatus _submitStatus;
  @override
  SubmitStatus get submitStatus => _submitStatus;

  @override
  set submitStatus(SubmitStatus status) => _submitStatus = status;

  final VoidCallback _onOpenError;
  final VoidCallback _onOpenSuccess;
  final AsyncCallback _onPressed;

  bool _isBusy;
  @override
  bool get isBusy => _isBusy;

  bool _isDisabled;
  @override
  bool get isDisabled => _isDisabled;

  bool _isError;
  @override
  bool get isError => _isError;

  bool _isSuccess;
  @override
  bool get isSuccess => _isSuccess;

  bool _isActive;
  @override
  bool get isActive => _isActive;

  @override
  void openError() {
    if (_submitStatus == SubmitStatus.error) {
      _onOpenError();
    }
  }

  @override
  void openSuccess() {
    if (_submitStatus == SubmitStatus.success) {
      _onOpenSuccess();
    }
  }

  @override
  void onPressed() async {
    if (_submitStatus == SubmitStatus.active) {
      await _onPressed();
      if (_submitStatus == SubmitStatus.success) {
        this._onOpenSuccess();
      }
      if (_submitStatus == SubmitStatus.error) {
        this._onOpenError();
      }
    }
  }
}

//Submit button widget
class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key? key,
    required this.text,
    required this.successText,
    required this.status,
    required this.onPressed,
    required this.onError,
    required this.onSuccess,
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final SubmitStatus status;
  final String text;
  final String successText;
  final Duration transitionDuration;
  final VoidCallback onPressed;
  final VoidCallback onError;
  final VoidCallback onSuccess;

  //get status

  bool get _isActive => status == SubmitStatus.active;

  bool get _isDisabled => status == SubmitStatus.disabled;

  bool get _isBusy => status == SubmitStatus.busy;

  bool get _isError => status == SubmitStatus.error;

  bool get _isSuccess => status == SubmitStatus.success;

  void _onPressed() {
    switch (status) {
      case SubmitStatus.active:
        onPressed();
        break;
      case SubmitStatus.disabled:
        // do nothing.
        break;
      case SubmitStatus.busy:
        // do nothing.
        break;
      case SubmitStatus.error:
        onError();
        break;
      case SubmitStatus.success:
        onSuccess();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      borderRadius: BorderRadius.circular(25),
      color: _isDisabled || _isBusy ? Colors.grey : HexColor('#4e88ff'),
      child: InkWell(
        onTap: _onPressed,
        child: SubmitButtonShapeWidget(
          text: text,
          successText: successText,
          isActive: _isActive,
          isBusy: _isBusy,
          isError: _isError,
          isSuccess: _isSuccess,
          isDisabled: _isDisabled,
          transitionDuration: transitionDuration,
        ),
      ),
    );
  }
}

//Button shape Widget
// Place circular progress indicator inside the button when it is busy
// Place error icon inside the button when it is in error state
// Place success icon inside the button when it is in success state
// grey background when it is disabled
//Color(0xFF222744) background color when it is active

class SubmitButtonShapeWidget extends StatelessWidget {
  const SubmitButtonShapeWidget({
    Key? key,
    required this.text,
    required this.isActive,
    required this.isBusy,
    required this.isError,
    required this.isSuccess,
    required this.isDisabled,
    required this.successText,
    required this.transitionDuration,
  }) : super(key: key);

  //variables
  final String text;
  final String successText;
  final bool isActive;
  final bool isBusy;
  final bool isError;
  final bool isSuccess;
  final bool isDisabled;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: !isActive,
            child: isBusy || isDisabled
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : isError
                    ? const Icon(
                        Icons.error,
                        color: Colors.white,
                      )
                    : isSuccess
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : Container(),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            isBusy || isDisabled
                ? 'Please Wait'
                : (isSuccess ? successText : (isError ? 'Aborted' : text)),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
