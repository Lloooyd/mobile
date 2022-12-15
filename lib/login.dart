// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:mobile/common/constant.dart';
import 'package:mobile/common/dialog.dart';
import 'package:mobile/controller/studentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/home.dart';
import 'package:mobile/model/studentModel.dart';
import 'package:mobile/register.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final StudentController studentController = Get.put(StudentController());
  bool isLoading = false;
  bool isRequiredSno = false;
  bool isRequiredPassword = false;

  TextEditingController snoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> handleLoginClick() async {
    try {
      if (snoController.text == "") {
        isRequiredSno = true;
      }

      if (passwordController.text == "") {
        isRequiredPassword = true;
      }

      if (isRequiredSno || isRequiredPassword) {
        setState(() {});
        return;
      }

      Dialogs.loadDialog(context, "Please. wait...", "");

      var bytes = convert.utf8.encode(passwordController.text);
      var digest = sha256.convert(bytes);
      var body = convert.json.encode(
        {
          'sno': snoController.text,
          'password': digest.toString(),
        },
      );
      var client = http.Client();
      var url = Uri.parse("$kUrl/student/login");
      var resp = await client.post(url, headers: kHeader, body: body);
      print(resp.statusCode);
      Navigator.of(context).pop();

      if (resp.statusCode == 200) {
        var tmp = studentModelFromJson(resp.body);
        if (tmp.isNotEmpty) {
          studentController.setStudent(tmp[0]);
          Get.offAll(HomePage(student: tmp[0]));
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
      } else {
        // return [];
      }
    } catch (e) {
      Navigator.of(context).pop();
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return kLoading();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset(
                    "assets/images/logo3.png",
                    fit: BoxFit.fill,
                    height: 200,
                    width: 200,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Center(
                //   child: Text(
                //     "iREQUEST",
                //     textAlign: TextAlign.center,
                //     style: GoogleFonts.lato(
                //       fontSize: 24.0,
                //       color: Colors.white,
                //       fontWeight: FontWeight.w800,
                //     ),
                //   ),
                // ),
                TextFormField(
                  controller: snoController,
                  maxLines: 1,
                  maxLength: 20,
                  textAlign: TextAlign.center,
                  onChanged: (value) => {
                    setState(() {
                      isRequiredSno = false;
                      isRequiredPassword = false;
                    })
                  },
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFeatures: [FontFeature.proportionalFigures()],
                    ),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    counterText: "",
                    labelText: "Enter student no.",
                    labelStyle: GoogleFonts.lato(color: Colors.white),
                    hintStyle: GoogleFonts.lato(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  maxLines: 1,
                  maxLength: 100,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) => {
                    setState(() {
                      isRequiredSno = false;
                      isRequiredPassword = false;
                    })
                  },
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFeatures: [FontFeature.proportionalFigures()],
                    ),
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    counterText: "",
                    labelText: "Enter password",
                    labelStyle: GoogleFonts.lato(color: Colors.white),
                    hintStyle: GoogleFonts.lato(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.to(const RegisterPage()),
                        child: Center(
                          child: Text(
                            "Register",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => handleLoginClick(),
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "LOGIN",
                                style: GoogleFonts.lato(
                                  fontSize: 20.0,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
