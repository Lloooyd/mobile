// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api, unnecessary_new, use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:developer';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:mobile/common/dialog.dart';
import 'package:mobile/model/studentModel.dart';
import 'package:mobile/login.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/common/constant.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController snoController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isRequiredSno = false;
  bool isRequiredLastname = false;
  bool isRequiredPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> handleSubmitClick() async {
    try {
      if (snoController.text == "") {
        isRequiredSno = true;
      }

      if (lastnameController.text == "") {
        isRequiredLastname = true;
      }

      if (passwordController.text == "") {
        isRequiredPassword = true;
      }

      if (isRequiredSno || isRequiredLastname || isRequiredPassword) {
        setState(() {});
        return;
      }

      var confirm = await Dialogs.confirmationDialog(
          context, "SUBMIT", "Are you sure you want to submit?");
      if (confirm == DialogAction.yes) {
        Dialogs.loadDialog(context, "Pls. wait...", "");

        // await Future.delayed(const Duration(seconds: 2));
        var student = await getStudent();
        if (student.isEmpty) {
          Navigator.of(context).pop();
          await Dialogs.errorDialog(context, "Record not found.");
        } else {
          inspect(student);
          if (!EmailValidator.validate(student[0].email!)) {
            Navigator.of(context).pop();
            await Dialogs.errorDialog(context, "Invalid email address.");
            return;
          }

          var otp = new Random().nextInt(9000) + 1000;
          sendOTP(student[0].email!, otp);

          Navigator.of(context).pop();
          var otpResult = await Dialogs.otpDialog(
            context,
            student[0].email!,
            otp.toString(),
          );

          if (otpResult == DialogAction.yes) {
            Dialogs.loadDialog(context, "Please. wait...", "");
            var bytes = convert.utf8.encode(passwordController.text);
            var digest = sha256.convert(bytes);
            var body = convert.json.encode(
              {
                'sno': snoController.text,
                'lastname': lastnameController.text,
                'password': digest.toString(),
              },
            );

            var client = http.Client();
            var url = Uri.parse("$kUrl/student/register");
            var resp = await client.post(url, headers: kHeader, body: body);
            if (resp.statusCode == 200) {
              Navigator.of(context).pop();
              await Dialogs.successDialog(
                  context, "Record successfully updated.");
              Get.offAll(LoginPage());
            } else {
              Navigator.of(context).pop();
              Dialogs.errorDialog(context, kRuntimeErrorMessage);
            }
          }
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Future<List<StudentModel>> getStudent() async {
    try {
      var body = convert.json.encode(
        {
          'sno': snoController.text,
          'lastname': lastnameController.text,
        },
      );
      var client = http.Client();
      var url = Uri.parse("$kUrl/student/exist");
      var resp = await client.post(url, headers: kHeader, body: body);
      print(resp.body);

      if (resp.statusCode == 200) {
        var tmp = studentModelFromJson(resp.body);
        return tmp;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  

  Future<void> sendOTP(email, otp) async {
    try {
      var body = convert.json.encode(
        {
          'otp': otp,
          'email': email,
        },
      );

      print(body);

      var client = http.Client();
      var url = Uri.parse("$kUrl/mail/otp");
      await client.post(url, headers: kHeader, body: body);
    } catch (error) {
      throw new Exception(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'REGISTER',
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
        backgroundColor: kLightColor,
        elevation: 15,
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
                    'Student No.',
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
                    controller: snoController,
                    maxLines: 1,
                    maxLength: 20,
                    onChanged: (value) => {
                      setState(() {
                        isRequiredSno = false;
                        isRequiredLastname = false;
                        isRequiredPassword = false;
                      })
                    },
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black),
                    decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        // fillColor: kTextFillColor,
                        labelStyle: GoogleFonts.lato(color: Colors.grey),
                        hintStyle: GoogleFonts.lato(color: Colors.grey),
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: kPrimaryColor))),
                  ),
                ),
                if (isRequiredSno)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: kRequired(),
                  ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                  child: Text(
                    'Lastname',
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
                    controller: lastnameController,
                    maxLines: 1,
                    maxLength: 250,
                    onChanged: (value) => {
                      setState(() {
                        isRequiredSno = false;
                        isRequiredLastname = false;
                        isRequiredPassword = false;
                      })
                    },
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black),
                    decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        // fillColor: kTextFillColor,
                        labelStyle: GoogleFonts.lato(color: Colors.grey),
                        hintStyle: GoogleFonts.lato(color: Colors.grey),
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: kPrimaryColor))),
                  ),
                ),
                if (isRequiredLastname)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: kRequired(),
                  ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                  child: Text(
                    'Password',
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
                    controller: passwordController,
                    maxLines: 1,
                    maxLength: 250,
                    obscureText: true,
                    onChanged: (value) => {
                      setState(() {
                        isRequiredSno = false;
                        isRequiredLastname = false;
                        isRequiredPassword = false;
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
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: kPrimaryColor))),
                  ),
                ),
                if (isRequiredPassword)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: kRequired(),
                  ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => handleSubmitClick(),
                    child: Container(
                      width: 200,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
