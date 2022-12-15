// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api, unnecessary_new, use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:io';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:mobile/common/dialog.dart';
import 'package:mobile/common/drawer.dart';
import 'package:mobile/controller/studentController.dart';
import 'package:mobile/model/studentModel.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/common/constant.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final StudentController studentController = Get.find();
  StudentModel student = StudentModel();

  bool isRequiredSno = false;
  bool isRequiredLastname = false;
  bool isRequiredFirstname = false;
  bool isRequiredMiddlename = false;
  bool isRequiredProgram = false;
  bool isRequiredYearlevel = false;
  bool isRequiredEmail = false;
  bool isRequiredMobile = false;
  bool isRequiredAddress = false;
  // bool isRequiredPassword = false;

  bool isLoading = false;

  TextEditingController snoController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController middlenameController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController yearlevelController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initLoad();
  }

  void initLoad() async {
    student = studentController.student.value;
    snoController = new TextEditingController(text: student.sno);
    lastnameController = TextEditingController(text: student.lastname);
    firstnameController = TextEditingController(text: student.firstname);
    middlenameController = TextEditingController(text: student.middlename);
    programController = TextEditingController(text: student.program);
    majorController = TextEditingController(text: student.major);
    yearlevelController = TextEditingController(text: student.yearlevel);
    emailController = TextEditingController(text: student.email);
    mobileController = TextEditingController(text: student.mobile);
    addressController = TextEditingController(text: student.address);
    // passwordController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> handleSubmitClick() async {
    try {
      isRequiredSno = snoController.text == "";
      isRequiredLastname = lastnameController.text == "";
      isRequiredFirstname = firstnameController.text == "";
      isRequiredMiddlename = middlenameController.text == "";
      isRequiredProgram = programController.text == "";
      isRequiredYearlevel = yearlevelController.text == "";
      isRequiredEmail = emailController.text == "";
      isRequiredMobile = mobileController.text == "";
      isRequiredAddress = addressController.text == "";
      // isRequiredPassword = passwordController.text == "";

      if (isRequiredSno ||
          isRequiredLastname ||
          isRequiredFirstname ||
          isRequiredMiddlename ||
          isRequiredProgram ||
          isRequiredYearlevel ||
          isRequiredEmail ||
          isRequiredMobile ||
          isRequiredAddress) {
        setState(() {});
        return;
      }

      var confirm = await Dialogs.confirmationDialog(
          context, "SUBMIT", "Are you sure you want to submit?");
      if (confirm == DialogAction.yes) {
        Dialogs.loadDialog(context, "Pls. wait...", "");

        var body = convert.json.encode(
          {
            "sno": snoController.text,
            "lastname": lastnameController.text,
            "firstname": firstnameController.text,
            "middlename": middlenameController.text,
            "program": programController.text,
            "major": majorController.text,
            "yearlevel": yearlevelController.text,
            "email": emailController.text,
            "mobile": mobileController.text,
            "address": addressController.text,
            "oldsno": student.sno,
            "oldlastname": student.lastname,
          },
        );

        var client = http.Client();
        var url = Uri.parse("$kUrl/student/update");
        var resp = await client.post(url, headers: kHeader, body: body);
        if (resp.statusCode == 200) {
          student.sno = snoController.text;
          student.lastname = lastnameController.text;
          student.firstname = firstnameController.text;
          student.middlename = middlenameController.text;
          student.program = programController.text;
          student.major = majorController.text;
          student.yearlevel = yearlevelController.text;
          student.email = emailController.text;
          student.mobile = mobileController.text;
          student.address = addressController.text;
          studentController.setStudent(student);

          Navigator.of(context).pop();
          await Dialogs.successDialog(context, "Record successfully updated.");
        } else {
          Navigator.of(context).pop();
          Dialogs.errorDialog(context, kRuntimeErrorMessage);
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Widget item(label, controller, obscureText, required) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                color: kLightColor,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            controller: controller,
            maxLines: 1,
            maxLength: 200,
            obscureText: obscureText,
            onChanged: (value) => {
              setState(() {
                isRequiredSno = false;
                isRequiredLastname = false;
                isRequiredFirstname = false;
                isRequiredMiddlename = false;
                isRequiredProgram = false;
                isRequiredYearlevel = false;
                isRequiredEmail = false;
                isRequiredMobile = false;
                isRequiredAddress = false;
              })
            },
            style: GoogleFonts.lato(
                fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
                counterText: "",
                filled: true,
                // fillColor: kTextFillColor,
                labelStyle: GoogleFonts.lato(color: Colors.grey),
                hintStyle: GoogleFonts.lato(color: Colors.grey),
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: kPrimaryColor))),
          ),
          SizedBox(
            height: 4,
          ),
          if (required) kRequired()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return kLoading();

    return Scaffold(
      drawer: CustomMenu.getDrawer(context, student),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'PROFILE',
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
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => initLoad(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                  child: Text(
                    'Personal Information',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: kLightColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                item(
                  "Student No.",
                  snoController,
                  false,
                  isRequiredSno,
                ),
                item(
                  "Lastname",
                  lastnameController,
                  false,
                  isRequiredLastname,
                ),
                item(
                  "Firstname",
                  firstnameController,
                  false,
                  isRequiredFirstname,
                ),
                item(
                  "Middlename",
                  middlenameController,
                  false,
                  isRequiredMiddlename,
                ),
                item(
                  "Email",
                  emailController,
                  false,
                  isRequiredEmail,
                ),
                item(
                  "Mobile",
                  mobileController,
                  false,
                  isRequiredMobile,
                ),
                item(
                  "Address",
                  addressController,
                  false,
                  isRequiredAddress,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                  child: Text(
                    'Program',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: kLightColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                item(
                  "Program",
                  programController,
                  false,
                  isRequiredProgram,
                ),
                item(
                  "Major",
                  majorController,
                  false,
                  false,
                ),
                item(
                  "Year Level",
                  yearlevelController,
                  false,
                  isRequiredYearlevel,
                ),
                SizedBox(
                  height: 10,
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                //   child: Text(
                //     'Security',
                //     style: GoogleFonts.openSans(
                //       textStyle: TextStyle(
                //           color: kLightColor,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w800),
                //     ),
                //   ),
                // ),
                // item(
                //   "Password",
                //   passwordController,
                //   true,
                //   isRequiredPassword,
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: GestureDetector(
                          onTap: () => handleSubmitClick(),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.save_rounded,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Submit",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        child: GestureDetector(
                          onTap: () => {},
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Reset Password",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
