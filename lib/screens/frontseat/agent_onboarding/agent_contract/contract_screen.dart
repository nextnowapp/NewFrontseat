import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/kyc_step_model.dart';
import '../../../../utils/Utils.dart';
import '../../services/kyc_api.dart';
import '../../../../utils/widget/textwidget.dart';
import 'controller/contract_bloc.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({Key? key}) : super(key: key);

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  String? pdfFlePath;
  String? directory;
  var bytes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPdf();
    _localPath().then((value) {
      setState(() {
        directory = value;
      });
    });
  }

  final kycStepModelController = Get.put(KycStepModel());

  Future<String> getPath() async {
    var url = await KycApi.getPDF();
    var fileName = url.split('/').last;
    var filePath = File('$directory/$fileName');
    // return filePath;
    if (await filePath.exists()) {
      return filePath.path;
    }
    final response = await http.get(Uri.parse(url));
    bytes = response.bodyBytes;
    await filePath.writeAsBytes(response.bodyBytes);
    return filePath.path;
  }

  void loadPdf() async {
    pdfFlePath = await getPath();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractBloc, ContractState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const TextWidget(txt: 'Contract Agreement'),
            backgroundColor: Colors.red,
          ),
          body: Column(
            children: [
              if (pdfFlePath != null)
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: PdfView(path: pdfFlePath!),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ))),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfView(path: pdfFlePath!),
                            ),
                          );
                        },
                        child: TextWidget(
                          txt: 'View PDF',
                          size: 10.sp,
                          weight: FontWeight.w500,
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ))),
                        onPressed: () async {
                          var fileName = 'Agent Contract';
                          var status = await Permission.storage.status;
                          if (!status.isGranted) {
                            await Permission.storage.request();
                          }
                          // the downloads folder path
                          String tempPath = '/storage/emulated/0/Download';
                          var filePath = tempPath + '/${fileName}.pdf';
                          final buffer = bytes.buffer;
                          //save file
                          var exists = await File(filePath).exists();
                          if (exists == true) {
                            File(filePath).delete();
                          }

                          await File(filePath).writeAsBytes(buffer.asUint8List(
                              bytes.offsetInBytes, bytes.lengthInBytes));

                          // view file using system default viewer
                          OpenFile.open(filePath);
                          Utils.showToast('File Saved at $filePath');
                        },
                        child: TextWidget(
                          txt: 'Download Contract',
                          size: 10.sp,
                          weight: FontWeight.w500,
                        )),
                  ),
                ],
              ),
              Utils.sizedBoxHeight(20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(state.aceeptFirstAgreement
                          ? Icons.check_circle
                          : Icons.circle_outlined),
                      color: state.aceeptFirstAgreement
                          ? Colors.green
                          : Colors.grey,
                      onPressed: () {
                        context
                            .read<ContractBloc>()
                            .add(AcceptFirstCheckEvent());
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Expanded(
                      child: Text(
                        'I accept the terms and conditions of this contract',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(state.aceeptSecondAgreement
                          ? Icons.check_circle
                          : Icons.circle_outlined),
                      color: state.aceeptSecondAgreement
                          ? Colors.green
                          : Colors.grey,
                      onPressed: () {
                        context
                            .read<ContractBloc>()
                            .add(AcceptSecondCheckEvent());
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Expanded(
                      child: Text(
                        'I accept my signature as valid and correct',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(state.aceeptThirdAgreement
                          ? Icons.check_circle
                          : Icons.circle_outlined),
                      color: state.aceeptThirdAgreement
                          ? Colors.green
                          : Colors.grey,
                      onPressed: () {
                        context
                            .read<ContractBloc>()
                            .add(AcceptThirdCheckEvent());
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Expanded(
                      child: Text(
                        'I accept that my personal data be used to complete this contract',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Utils.sizedBoxHeight(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(color: Colors.red)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          context.read<ContractBloc>().add(AcceptAgreementEvent(
                              value: 'reject', context: context));
                        },
                        child: const TextWidget(
                          txt: 'Reject',
                          weight: FontWeight.w500,
                          clr: Colors.red,
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ))),
                        onPressed: () {
                          if (state.aceeptFirstAgreement &&
                              state.aceeptSecondAgreement &&
                              state.aceeptThirdAgreement) {
                            context.read<ContractBloc>().add(
                                AcceptAgreementEvent(
                                    value: 'accept', context: context));
                          } else {
                            Utils.showToast('accept agreement to continue');
                          }
                        },
                        child: const TextWidget(
                          txt: 'Accept',
                          weight: FontWeight.w500,
                        )),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<String> _localPath() async {
    Directory? directory;
    String path;

    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    path = directory!.path;
    return path;
  }
}
