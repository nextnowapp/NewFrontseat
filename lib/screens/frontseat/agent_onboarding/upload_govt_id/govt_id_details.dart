import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_govt_id/govt_id_upload_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/Utils.dart';
import '../../../../utils/frontseat_constants.dart';
import '../../../../utils/widget/textwidget.dart';
import '../../../../utils/widget/txtbox.dart';
import 'controller/upload_govt_id_bloc.dart';

class GovtIdDetails extends StatefulWidget {
  const GovtIdDetails({Key? key}) : super(key: key);

  @override
  State<GovtIdDetails> createState() => _GovtIdDetailsState();
}

class _GovtIdDetailsState extends State<GovtIdDetails> {
  final TextEditingController drivingLicensce = TextEditingController();
  final TextEditingController nid = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  String? _selectedIdentityDocument;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: BlocBuilder<UploadGovtIdBloc, UploadGovtIdState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Identity Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              shadowColor: Colors.transparent,
              automaticallyImplyLeading: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const Text(
                    'Please provide your government issued ID',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const TextWidget(
                            txt: "Identity Document",
                            size: 18,
                            clr: Colors.red,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FormField<String>(
                            builder: (FormFieldState<String> stat) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    hintText:
                                        'Please select identity Document type',
                                    label:
                                        const Text('Identity Document type*'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                isEmpty: _selectedIdentityDocument == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedIdentityDocument,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedIdentityDocument = newValue;
                                        stat.didChange(newValue);
                                      });
                                    },
                                    items:
                                        identityDocuments.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Visibility(
                              visible: _selectedIdentityDocument != null,
                              child: TxtField(
                                hint: 'Identity Document ID*',
                                controller: nid,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Identity Document ID is required';
                                  }
                                  return null;
                                },
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const TextWidget(
                            txt: "Driving Licence (Optional)",
                            size: 18,
                            clr: Colors.red,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TxtField(
                            hint: 'Driving Licence ID',
                            formatter: [
                              FilteringTextInputFormatter.singleLineFormatter,
                            ],
                            controller: drivingLicensce,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            child: Column(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: RoundedLoadingButton(
                                    resetAfterDuration: true,
                                    resetDuration: const Duration(seconds: 10),
                                    width: 100.w,
                                    borderRadius: 10,
                                    color: Colors.red,
                                    controller: _btnController,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        if (_selectedIdentityDocument != null) {
                                          context.read<UploadGovtIdBloc>().add(
                                              UploadGovtIdDetailsEvent(
                                                  idDocument: nid.text,
                                                  drivingLicense:
                                                      drivingLicensce.text));
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const GovtIdUploadScreen()));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                'Identity Document is Required'),
                                          ));
                                          _btnController.reset();
                                        }
                                      } else {
                                        _btnController.reset();
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'NEXT',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
