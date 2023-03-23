import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nextschool/screens/frontseat/agent_onboarding/upload_govt_id/govt_id_upload_screen.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sizer/sizer.dart';

import '../../../../utils/widget/textwidget.dart';
import '../../../../utils/widget/txtbox.dart';
import '../../frontseat_constants.dart';
import '../../model/frontseat_user_detail_model.dart';
import 'controller/upload_govt_id_bloc.dart';

class GovtIdDetails extends StatefulWidget {
  const GovtIdDetails({Key? key, this.data}) : super(key: key);
  final UserDetailModel? data;
  @override
  State<GovtIdDetails> createState() => _GovtIdDetailsState();
}

class _GovtIdDetailsState extends State<GovtIdDetails> {
  final TextEditingController drivingLicensce = TextEditingController();
  final TextEditingController rsaID = TextEditingController();
  final TextEditingController passport = TextEditingController();
  final TextEditingController asylum = TextEditingController();
  final TextEditingController country = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  String? _selectedIdentityDocument;
  String? selectedCountry;
  String? documenttype;
  String? documentno;
  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _selectedIdentityDocument =
          widget.data!.data!.agentDetails!.documentType ?? '';
      selectedCountry = widget.data!.data!.agentDetails!.countryName ?? '';
      drivingLicensce.text =
          widget.data!.data!.agentDetails!.drivingLicenseId ?? '';
      rsaID.text = widget.data!.data!.agentDetails!.idNumber ?? '';
      asylum.text = widget.data!.data!.agentDetails!.asylumDocNo ?? '';
      passport.text = widget.data!.data!.agentDetails!.passportNo ?? '';
    }
  }

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
            resizeToAvoidBottomInset: true,
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
              // leading: IconButton(
              //   icon: const Icon(
              //     Icons.arrow_back_ios,
              //     color: Colors.black,
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
            ),
            body: SingleChildScrollView(
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
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(12.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const TextWidget(
                            txt: 'Identity Document',
                            size: 18,
                            clr: Colors.red,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          getDocumentTypeDropdown(),
                          Visibility(
                              visible: _selectedIdentityDocument ==
                                      'Asylum Document' ||
                                  _selectedIdentityDocument ==
                                      'Passport Document',
                              child: getCountryDropDown()),
                          const SizedBox(
                            height: 20,
                          ),
                          Visibility(
                              visible: _selectedIdentityDocument ==
                                  'Asylum Document',
                              child: TxtField(
                                hint: 'Asylum Document No.*',
                                controller: asylum,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Asylum Document No. is required';
                                  }
                                  return null;
                                },
                              )),
                          Visibility(
                              visible: _selectedIdentityDocument ==
                                  'Passport Document',
                              child: TxtField(
                                hint: 'Passport Document No.*',
                                controller: passport,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Passport Document No. is required';
                                  }
                                  return null;
                                },
                              )),
                          Visibility(
                              visible: _selectedIdentityDocument == 'RSA ID',
                              child: TxtField(
                                length: 13,
                                type: TextInputType.number,
                                hint: 'Identity Document No.*',
                                controller: rsaID,
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
                            txt: 'Driving Licence (Optional)',
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
                                      if (_selectedIdentityDocument ==
                                          'RSA ID') {
                                        documenttype = 'RasId';
                                        passport.clear();
                                        asylum.clear();
                                        selectedCountry = '';
                                      } else if (_selectedIdentityDocument ==
                                          'Asylum Document') {
                                        documenttype = 'asylumDocument';
                                        rsaID.clear();
                                        passport.clear();
                                      } else if (_selectedIdentityDocument ==
                                          'Passport Document') {
                                        documenttype = 'PassportDocument';
                                        rsaID.clear();
                                        asylum.clear();
                                      }
                                      // log(rsaID.text+docum)
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        if (_selectedIdentityDocument != null) {
                                          context.read<UploadGovtIdBloc>().add(
                                              UploadGovtIdDetailsEvent(
                                                  data: widget.data,
                                                  idDocument: rsaID.text,
                                                  documentType:
                                                      _selectedIdentityDocument!,
                                                  passport: passport.text,
                                                  country: selectedCountry,
                                                  asylum: asylum.text,
                                                  drivingLicense:
                                                      drivingLicensce.text));
                                          if (widget.data == null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const GovtIdUploadScreen()));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GovtIdUploadScreen(
                                                          data: widget.data,
                                                        )));
                                          }
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
                  const SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getCountryDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.sizedBoxHeight(20),
        Text(
          'Country*',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        SearchField<String>(
          controller: country,
          autoCorrect: true,
          suggestions:
              countries.map((e) => SearchFieldListItem(e, item: e)).toList(),
          suggestionState: Suggestion.expand,
          hasOverlay: false,
          searchStyle: const TextStyle(fontSize: 16, color: Colors.black),
          validator: (x) {
            if (x == null ||
                x.isEmpty ||
                !countries.map((e) => e).contains(x)) {
              return 'Country is required';
            }
            return null;
          },
          searchInputDecoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            suffixIcon: const Icon(Icons.search),
            fillColor: HexColor('#5374ff'),
            errorStyle: TextStyle(
              fontSize: 8.sp,
              color: HexColor('#de5151'),
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            hintStyle: TextStyle(
              color: HexColor('#8e9aa6'),
              fontSize: 12.sp,
              fontFamily: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
              ).fontFamily,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#d5dce0'),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#5374ff'),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#de5151'),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: HexColor('#de5151'),
              ),
            ),
          ),
          onSuggestionTap: (x) {
            setState(() {
              selectedCountry = x.item!;
            });
            FocusScope.of(context).requestFocus(FocusNode());
          },
          maxSuggestionsInViewPort: 6,
          itemHeight: 50,
        ),
      ],
    );
  }

  Widget getDocumentTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Identity document type*',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 10.sp,
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
            ).fontFamily,
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        DropdownSearch<String>(
          // mode: Mode.MENU,
          validator: (value) {
            if (value == null) {
              return 'Document type is required';
            }
            return null;
          },
          // showSelectedItems: true,
          items: identityDocuments,

          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontFamily: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            );
          },

          popupProps: PopupProps.menu(
            itemBuilder: (context, item, isSelected) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.sp, vertical: 10.sp),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontFamily: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                  ),
                  Divider(
                    color: HexColor('#8e9aa6'),
                    thickness: 0.5,
                  )
                ],
              );
            },
            showSelectedItems: true,
            constraints: BoxConstraints(
              maxHeight: (3 * 42.sp) < 170.sp ? (3 * 42.sp) : 170.sp,
            ),
          ),
          dropdownDecoratorProps: dropdownDecoratorProps,
          onChanged: (dynamic newValue) {
            setState(() {
              _selectedIdentityDocument = newValue;
            });
          },
          selectedItem: _selectedIdentityDocument,
        ),
      ],
    );
  }
}
