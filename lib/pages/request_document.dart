// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api, unnecessary_new, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:mobile/common/drawer.dart';
import 'package:mobile/custom_widgets/elevated_button_widget.dart';
import 'package:mobile/custom_widgets/text_widget.dart';
import 'package:mobile/model/lookUpModel.dart';
import 'package:mobile/model/requestModel.dart';
import 'package:mobile/model/studentModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/common/constant.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RequestDocuments extends StatefulWidget {
  final StudentModel student;
  const RequestDocuments({Key? key, required this.student}) : super(key: key);

  @override
  _RequestDocumentsState createState() => _RequestDocumentsState();
}

class _RequestDocumentsState extends State<RequestDocuments> {
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

      if (resp.statusCode == 200) {
        if(formsList.isNotEmpty) {
          requestList = requestModelFromJson(resp.body);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  String getStatus(int status) {
    var str = "Pending";
    if (status == 1) str = "Approved";
    if (status == 2) str = "For Pickup";
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
                width: mediaWidth,
                margin: EdgeInsets.only(
                  bottom: mediaWidth * 0.05,
                  top: mediaWidth * 0.07
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
                                  SizedBox(
                                    height: mediaWidth * 0.05,
                                  ),
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
                                              text: getStatus(request.status!),
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
                  height: mediaWidth * 0.10,
                ),
        ],
      ),
        ),
      ),
    );
  }
}
