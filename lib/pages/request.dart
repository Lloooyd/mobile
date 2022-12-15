// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api, unnecessary_new, use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:mobile/common/dialog.dart';
import 'package:mobile/common/drawer.dart';
import 'package:mobile/controller/studentController.dart';
import 'package:mobile/model/studentModel.dart';
import 'package:mobile/login.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/common/constant.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:mobile/pages/request_form.dart';

class RequestPage extends StatefulWidget {
  // final StudentModel student;
  const RequestPage({Key? key, }) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  // StudentModel student = StudentModel();

  @override
  void initState() {
    super.initState();
    // student = widget.student;
  }

  void initLoad() async {
    // student = widget.student;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final StudentController studentController = Get.put(StudentController());
    var docid = arguments['docid'];
    var docdesc = arguments['docdesc'];
    var email = arguments['email'];

    getStudentData() async {
      if(arguments['sno'] != "")  {
        var client = http.Client();
        var url = Uri.parse("$kUrl/student/data");
        var body = convert.json.encode(
        {
          'sno': await arguments['sno'],
        },
      );
        var resp = await client.post(url, headers: kHeader, body: body);

        inspect(resp);

        if (resp.statusCode == 200) {
          var tmp = studentModelFromJson(resp.body);
          if (tmp.isNotEmpty) {
              studentController.setStudent(tmp[0]);
          } else {
            Get.snackbar(
              "ERROR",
              "Invalid username or password",
              snackPosition: SnackPosition.BOTTOM,
              icon: const Icon(
                Icons.error_rounded,
                color: Colors.red,
              ),
            );
          }
        }
      }
    }

    getStudentData();

    return Scaffold(
      // drawer: CustomMenu.getDrawer(context, student),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'REQUEST DOCUMENT',
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
        backgroundColor: kLightColor,
        elevation: 15,
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     tooltip: 'Refresh',
        //     onPressed: () => initLoad(),
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     tooltip: 'New',
        //     onPressed: () => exit(0),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: RequestForm(student: studentController.student, sno: arguments['sno'], docid: docid, docdesc: docdesc, email: arguments['email'])
          ),
        ),
      ),
    );
  }
}
