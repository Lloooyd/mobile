import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/custom_widgets/elevated_button_widget.dart';
import 'package:mobile/custom_widgets/text_widget.dart';
import 'package:mobile/model/lookUpModel.dart';
import 'package:mobile/model/studentModel.dart';
import 'dart:convert' as convert;


import '../common/constant.dart';

class RequestForm extends StatefulWidget {
  final Rx<StudentModel> student;
  final String sno;
  final int docid;
  final String docdesc;
  final String email;
  const RequestForm({super.key, required this.student, required this.docid, required this.docdesc, required this.sno, required this.email});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final formKey = GlobalKey<FormBuilderState>();
  List<LookUpModel> formsList = [];


  @override
  void initState() {
    initLoad();
  }

  void initLoad() async {
    await Future.wait([
      getForms(),
    ]);
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

  checkIfRequestExist() async {

    try {
      var client = http.Client();
      var url = Uri.parse("$kUrl/request/exist");
      var body = convert.json.encode({
        "sno": widget.sno,
        "docid": widget.docid,
      });

      var resp = await client.post(url, headers: kHeader, body: body);

      if (resp.statusCode == 200) {
        if(resp.body == "[]") {
          addRequest();
        }else {
          Get.snackbar(
            "Request unsuccessful!",
            "You have existing requested document.",
            snackPosition: SnackPosition.TOP,
            icon: const Icon(
              Icons.error_rounded,
              color: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  addRequest() async {
    try {
      var client = http.Client();
      var url = Uri.parse("$kUrl/request/add");
      var body = convert.json.encode({
        "sno": widget.sno,
        "docid": widget.docid,
        "email": widget.email,
      });

      var resp = await client.post(url, headers: kHeader, body: body);
      if (resp.statusCode == 200) {
        // var data = convert.jsonDecode(resp.body);
        Get.snackbar(
            "Success!",
            "Your request successfully submitted! We will notify you for updates. Thank you.",
            snackPosition: SnackPosition.TOP,
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;

    return Container(
      child: FormBuilder(
        key: formKey,
        autovalidateMode: AutovalidateMode.disabled, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            const TextWidget(
              text: 'REVIEW DATA',
              variant: 'primary',
              fontWeight: FontWeight.bold,
              size: 'md',
            ),
            const Divider(thickness: 1,),
            SizedBox(
              height: mediaWidth * 0.030,
            ),
            const TextWidget(
              text: 'Student Information',
              variant: 'primary',
              fontWeight: FontWeight.bold,
              size: 'xsm',
            ),
            SizedBox(
              height: mediaWidth * 0.03,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        text: 'Student Number',
                        variant: 'light',
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      const TextWidget(
                        text: 'First Name',
                        variant: 'light',
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      const TextWidget(
                        text: 'Middle Name',
                        variant: 'light',
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      const TextWidget(
                        text: 'Last Name',
                        variant: 'light',
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      const TextWidget(
                        text: 'Program',
                        variant: 'light',
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      const TextWidget(
                        text: 'Major',
                        variant: 'light',
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      const TextWidget(
                        text: 'Year Level',
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
                        text: widget.sno,
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      TextWidget(
                        text: widget.student.value.firstname ?? "",
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      TextWidget(
                        text: widget.student.value.middlename ?? "",
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      TextWidget(
                        text: widget.student.value.lastname ?? "",
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      TextWidget(
                        text: widget.student.value.program ?? "",
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                       SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      TextWidget(
                        text: widget.student.value.major ?? "",
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                       SizedBox(
                        height: mediaWidth * 0.01,
                      ),
                      TextWidget(
                        text: widget.student.value.yearlevel ?? "",
                        size: 'xs',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: mediaWidth * 0.05,
            ),
            const Divider(thickness: 1,),
            SizedBox(
              height: mediaWidth * 0.05,
            ),
            const TextWidget(
              text: 'Document Type',
              variant: 'primary',
              fontWeight: FontWeight.bold,
              size: 'xsm',
            ),
            SizedBox(
              height: mediaWidth * 0.03,
            ),
            TextWidget(
              text: widget.docdesc,
              size: 'xs',
              fontWeight: FontWeight.bold,
            ),
            SizedBox(
              height: mediaWidth * 0.1,
            ),
            SizedBox(
              width: mediaWidth,
              child: ElevatedButtonWidget(
                text: 'Submit Request', 
                onPressed: () {
                  checkIfRequestExist();
                },
              ),
            ),
           ],
          ),
      )
    );
  }
}