// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api, unnecessary_new, use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:intl/intl.dart';
import 'package:mobile/common/dialog.dart';
import 'package:mobile/common/drawer.dart';
import 'package:mobile/custom_widgets/elevated_button_widget.dart';
import 'package:mobile/custom_widgets/text_widget.dart';
import 'package:mobile/model/lookUpModel.dart';
import 'package:mobile/model/requestModel.dart';
import 'package:mobile/model/rowInsertModel.dart';
import 'package:mobile/model/studentModel.dart';
import 'package:mobile/login.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/common/constant.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:mobile/pages/request.dart';


class HomePage extends StatefulWidget {
  final StudentModel student;
  const HomePage({Key? key, required this.student}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StudentModel student = StudentModel();
  List<LookUpModel> formsList = [];
  List<RequestModel> requestList = [];
  bool isLoading = false;

  TextEditingController copiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    student = widget.student;
    initLoad();
  }

  void initLoad() async {
    student = widget.student;
    await Future.wait([
      getForms(),
      getRequest(),
    ]);

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getForms() async {
    try {
      var client = http.Client();
      var url = Uri.parse("$kUrl/forms/list");
      var resp = await client.get(url, headers: kHeader);
      print(resp.statusCode);
      print(resp.body);

      if (resp.statusCode == 200) {
        formsList = lookUpModelFromJson(resp.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getRequest() async {
    try {
      var body = convert.json.encode(
        {
          'sno': student.sno,
        },
      );
      var client = http.Client();
      var url = Uri.parse("$kUrl/request/list");
      var resp = await client.post(url, headers: kHeader, body: body);
      print(resp.statusCode);
      print(resp.body);

      if (resp.statusCode == 200) {
        if(formsList.isNotEmpty) {
          requestList = requestModelFromJson(resp.body);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> reqExist(sno, docid) async {
    try {
      var body = convert.json.encode(
        {'sno': sno, 'docid': docid},
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/request/exist");
      var resp = await client.post(url, headers: kHeader, body: body);
      var tmp = lookUpModelFromJson(resp.body);
      if (tmp.isNotEmpty) {
        return true;
      }

      return false;
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
      throw Exception(error.toString());
    }
  }

  Future<int?> reqAdd(sno, docid, copies) async {
    try {
      var body = convert.json.encode(
        {
          'sno': sno,
          'docid': docid,
          'copies': copies,
          'reqdate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/request/add");
      var resp = await client.post(url, headers: kHeader, body: body);
      if (resp.statusCode == 200) {
        var tmp = rowInsertModelFromJson(resp.body);
        return tmp.insertId;
      }
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<void> handleOnRequestClick(LookUpModel model) async {
    try {
      var result = await requestEntry(context, student.sno!, model);
      if (result == DialogAction.yes) {
        Dialogs.loadDialog(context, "Please. wait...", "");
        var copies = copiesController.text;
        var id = await reqAdd(student.sno, model.id, copies);

        Navigator.of(context).pop();
        await Dialogs.successDialog(context, "Successfully saved.");
        initLoad();
      }

      print('handleOnRequestClick 2');
    } catch (error) {
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  String GetStatus(int status) {
    var str = "Pending";
    if (status == 1) str = "Approved";
    if (status == 2) str = "For Pickup";
    if (status == 3) str = "Completed";
    if (status == 4) str = "Rejected";
    return str;
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) return kLoading();

    var mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: CustomMenu.getDrawer(context, student),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'iREQUEST',
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
        backgroundColor: kLightColor,
        elevation: 15,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => initLoad(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Exit',
            onPressed: () => exit(0),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: mediaWidth * 0.05
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Container(
                  padding: EdgeInsets.only(
                    top: mediaWidth * 0.10,
                    bottom: mediaWidth * 0.03
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/logo4.png",
                    fit: BoxFit.fill,
                    height: mediaWidth * 0.350,
                  ),
                ),
                TextWidget(
                  text: 'Hi ${student.firstname}!',
                  fontWeight: FontWeight.bold,
                  size: 'md',
                ),
                SizedBox(
                  height: mediaWidth * 0.03,
                ),
                TextWidget(
                  text: 'Select type of Document you want to request.',
                  variant: 'primary',
                  size: 'xs',
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: mediaWidth * 0.10,
                ),
                formsList.isNotEmpty ? (
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: formsList
                      .map(
                        (form) => GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/requestpage', arguments: {"sno": student.sno, "email": student.email, "docid": form.id, "docdesc": form.description});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.8),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(
                                    0.0,
                                    5.0,
                                  ),
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                              bottom: mediaWidth * 0.030,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: mediaWidth * 0.030,
                              horizontal: mediaWidth * 0.050
                            ),
                            child: TextWidget(
                              text: form.description ?? "",
                              variant: 'secondary',
                              size: 'xsm',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ).toList(),
                  )
                ) : Container(),
              SizedBox(
                height: mediaWidth * 0.05,
              ),
              Divider(thickness: 1.0,),
              Container(
                width: mediaWidth,
                margin: EdgeInsets.only(
                  bottom: mediaWidth * 0.05
                ),
                child: TextWidget(
                  text: 'RECENT REQUESTS',
                  variant: 'primary',
                  size: 'sm',
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
              ),
              formsList.isNotEmpty && requestList.isNotEmpty ? (
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: requestList
                      .map((request) {
                      var formData = formsList.firstWhere((form) => form.id == request.docid);

                          return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(
                                      0.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 5.0,
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(
                                bottom: mediaWidth * 0.040,
                              ),
                              padding: EdgeInsets.all(mediaWidth * 0.050),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextWidget(
                                    text: formData.description ?? "",
                                    variant: 'primary',
                                    size: 'sm',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: mediaWidth * 0.05,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              text: 'Requested Date',
                                              variant: 'light',
                                              size: 'xs',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              height: mediaWidth * 0.01,
                                            ),
                                            TextWidget(
                                              text: 'Expected Date',
                                              variant: 'light',
                                              size: 'xs',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              height: mediaWidth * 0.01,
                                            ),
                                            TextWidget(
                                              text: 'Status Date',
                                              variant: 'light',
                                              size: 'xs',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              text: request.reqdate ?? "",
                                              size: 'xs',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              height: mediaWidth * 0.01,
                                            ),
                                            TextWidget(
                                              text: request.expecteddate ?? "",
                                              size: 'xs',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(
                                              height: mediaWidth * 0.01,
                                            ),
                                            TextWidget(
                                              text: GetStatus(request.status!),
                                              size: 'xs',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                        }
                      ).toList(),
                  )
                ) : Container(),
                SizedBox(
                  height: mediaWidth * 0.05,
                ),
                ElevatedButtonWidget(
                  text: 'Show More', 
                  onPressed: () {},
                ),
                SizedBox(
                  height: mediaWidth * 0.10,
                ),
              
            

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     'MENU',
          //     style: GoogleFonts.openSans(
          //       color: kLightColor,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          // Container(
          //   color: kPrimaryColor,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: SizedBox(
          //       height: 150,
          //       child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           itemCount: formsList.length,
          //           itemBuilder: (context, index) {
          //             return menuItem(formsList[index]);
          //           }),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     'REQUEST',
          //     style: GoogleFonts.openSans(
          //       color: kLightColor,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          // Expanded(
          //   child: requestList.isEmpty
          //       ? kNoRecord(context)
          //       : ListView.builder(
          //           itemCount: requestList.length,
          //           itemBuilder: (context, index) {
          //             var formData = formsList.firstWhere((form) => form.id == requestList[index].docid);
          //             return Padding(
          //               padding: const EdgeInsets.all(10),
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     color: Colors.white.withOpacity(0.7),
          //                     borderRadius: BorderRadius.circular(10),
          //                     border: Border.all(color: kPrimaryColor)),
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(20),
          //                   child: Column(
          //                     // children: [
          //                     //   Row(
          //                     //     mainAxisAlignment: MainAxisAlignment.start,
          //                     //     crossAxisAlignment: CrossAxisAlignment.start,
          //                     //     children: [
          //                     //       Expanded(
          //                     //         flex: 1,
          //                     //         child: Text(
          //                     //           'Document',
          //                     //           // textAlign: TextAlign.right,
          //                     //           style: GoogleFonts.openSans(
          //                     //               //color: kLightColor,
          //                     //               ),
          //                     //         ),
          //                     //       ),
          //                     //       Expanded(
          //                     //         flex: 2,
          //                     //         child: Text(
          //                     //           formData.description ?? "",
          //                     //           style: GoogleFonts.openSans(
          //                     //             //color: kLightColor,
          //                     //             fontWeight: FontWeight.w600,
          //                     //           ),
          //                     //         ),
          //                     //       ),
          //                     //     ],
          //                     //   ),
          //                     //   SizedBox(
          //                     //     height: 4,
          //                     //   ),
          //                     //   Row(
          //                     //     mainAxisAlignment: MainAxisAlignment.start,
          //                     //     crossAxisAlignment: CrossAxisAlignment.start,
          //                     //     children: [
          //                     //       Expanded(
          //                     //         flex: 1,
          //                     //         child: Text(
          //                     //           'Req Date',
          //                     //           // textAlign: TextAlign.ce,
          //                     //           style: GoogleFonts.openSans(
          //                     //               //color: kLightColor,
          //                     //               ),
          //                     //         ),
          //                     //       ),
          //                     //       Expanded(
          //                     //         flex: 2,
          //                     //         child: Text(
          //                     //           requestList[index].reqdate!,
          //                     //           style: GoogleFonts.openSans(
          //                     //             //color: kLightColor,
          //                     //             fontWeight: FontWeight.w600,
          //                     //           ),
          //                     //         ),
          //                     //       ),
          //                     //     ],
          //                     //   ),
          //                     //   SizedBox(
          //                     //     height: 4,
          //                     //   ),
          //                     //   Row(
          //                     //     mainAxisAlignment: MainAxisAlignment.start,
          //                     //     crossAxisAlignment: CrossAxisAlignment.start,
          //                     //     children: [
          //                     //       Expanded(
          //                     //         flex: 1,
          //                     //         child: Text(
          //                     //           'Expected Date',
          //                     //           // textAlign: TextAlign.ce,
          //                     //           style: GoogleFonts.openSans(
          //                     //               //color: kLightColor,
          //                     //               ),
          //                     //         ),
          //                     //       ),
          //                     //       Expanded(
          //                     //         flex: 2,
          //                     //         child: Text(
          //                     //           requestList[index].expecteddate!,
          //                     //           style: GoogleFonts.openSans(
          //                     //             //color: kLightColor,
          //                     //             fontWeight: FontWeight.w600,
          //                     //           ),
          //                     //         ),
          //                     //       ),
          //                     //     ],
          //                     //   ),
          //                     //   SizedBox(
          //                     //     height: 4,
          //                     //   ),
          //                     //   Row(
          //                     //     mainAxisAlignment: MainAxisAlignment.start,
          //                     //     crossAxisAlignment: CrossAxisAlignment.start,
          //                     //     children: [
          //                     //       Expanded(
          //                     //         flex: 1,
          //                     //         child: Text(
          //                     //           'Status',
          //                     //           // textAlign: TextAlign.ce,
          //                     //           style: GoogleFonts.openSans(
          //                     //               //color: kLightColor,
          //                     //               ),
          //                     //         ),
          //                     //       ),
          //                     //       Expanded(
          //                     //         flex: 2,
          //                     //         child: Text(
          //                     //           GetStatus(requestList[index].status!),
          //                     //           style: GoogleFonts.openSans(
          //                     //             //color: kLightColor,
          //                     //             fontWeight: FontWeight.w600,
          //                     //           ),
          //                     //         ),
          //                     //       ),
          //                     //     ],
          //                     //   ),
          //                     //   SizedBox(
          //                     //     height: 20,
          //                     //   ),
          //                     //   Row(
          //                     //     mainAxisAlignment: MainAxisAlignment.start,
          //                     //     crossAxisAlignment: CrossAxisAlignment.start,
          //                     //     children: [
          //                     //       Expanded(
          //                     //         flex: 1,
          //                     //         child: Text(
          //                     //           '',
          //                     //           // textAlign: TextAlign.ce,
          //                     //           style: GoogleFonts.openSans(
          //                     //               //color: kLightColor,
          //                     //               ),
          //                     //         ),
          //                     //       ),
          //                     //       Expanded(
          //                     //         flex: 2,
          //                     //         child: InkWell(
          //                     //           onTap: () => {},
          //                     //           highlightColor: Colors.transparent,
          //                     //           focusColor: Colors.transparent,
          //                     //           splashColor: Colors.transparent,
          //                     //           child: Container(
          //                     //             decoration: BoxDecoration(
          //                     //               color: Colors.green.shade400,
          //                     //               border: Border.all(
          //                     //                 color: Colors.blueGrey,
          //                     //                 width: 1,
          //                     //               ),
          //                     //               borderRadius:
          //                     //                   BorderRadius.circular(10.0),
          //                     //             ),
          //                     //             // width: 120,
          //                     //             height: 50,
          //                     //             child: Center(
          //                     //               child: Text(
          //                     //                 "Tracking",
          //                     //                 style: GoogleFonts.openSans(
          //                     //                   textStyle: const TextStyle(
          //                     //                       color: Colors.white,
          //                     //                       fontSize: 16,
          //                     //                       fontWeight:
          //                     //                           FontWeight.w600),
          //                     //                 ),
          //                     //               ),
          //                     //             ),
          //                     //           ),
          //                     //         ),
          //                     //       ),
          //                     //     ],
          //                     //   )
          //                     // ],
                            
                            
                            
          //                   ),
          //                 ),
          //               ),
          //             );
          //           }),
          // )
        ],
      ),
        ),
      ),
    );
  }

  Widget menuItem(LookUpModel model) {
    return Card(
      elevation: 0,
      color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.5),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: InkWell(
        onTap: () => handleOnRequestClick(model),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  model.description!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DialogAction> requestEntry(
      context, String sno, LookUpModel model) async {
    bool isRequiredCopies = false;

    copiesController.text = "";

    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        void handleBtnSaveClick(setState) async {
          if (copiesController.text == "") {
            setState(() {
              isRequiredCopies = true;
            });
          }
          //for insert validation
          var exist = await reqExist(sno, model.id);
          if (exist) {
            await Dialogs.errorDialog(context, "Request already exist.");
            return;
          }

          Navigator.of(context).pop(DialogAction.yes);
        }

        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Container(
            decoration: BoxDecoration(
              color: kSelectorColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            height: 60.0,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Add New Request',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(DialogAction.cancel),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                // height: 200,
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                      child: Text(
                        'Document',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: kLightColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                      child: Text(
                        model.description!,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                      child: Text(
                        'Copies',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: kLightColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: copiesController,
                        maxLines: 1,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => {
                          setState(() {
                            isRequiredCopies = false;
                          })
                        },
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black),
                        decoration: InputDecoration(
                          counterText: "",
                          labelStyle: GoogleFonts.lato(color: Colors.grey),
                          hintStyle: GoogleFonts.lato(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: kSelectorColor),
                          ),
                        ),
                      ),
                    ),
                    if (isRequiredCopies)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                        child: kRequired(),
                      ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                      child: InkWell(
                        onTap: () => handleBtnSaveClick(setState),
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kSelectorColor,
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // width: 120,
                          height: 50,
                          child: Center(
                            child: Text(
                              "Submit",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
    return (action != null) ? action : DialogAction.cancel;
  }
}
