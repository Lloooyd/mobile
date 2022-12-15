import 'dart:io';
import 'package:mobile/common/constant.dart';
import 'package:mobile/home.dart';
import 'package:mobile/login.dart';
import 'package:mobile/model/studentModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/pages/profile.dart';
import 'package:mobile/pages/request.dart';
import 'package:mobile/pages/request_document.dart';

class CustomMenu {
  static Drawer getDrawer(BuildContext context, StudentModel student) {
    TextStyle titleStyle = GoogleFonts.openSans(
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600));

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ClipRRect(
                      // borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        "assets/images/logo3.png",
                        fit: BoxFit.fill,
                        height: 200,
                        width: 200,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Center(
                      child: Text("Student No. : ${student.sno}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    const SizedBox(height: 4.0),
                    Center(
                      child: Text(
                          '${student.firstname} ${student.middlename ?? ""} ${student.lastname}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    const SizedBox(height: 4.0),
                    Center(
                      child: Text(
                        '${student.email}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: kLightColor,
                size: 30.0,
                semanticLabel: 'Home',
              ),
              title: Text('Home', style: titleStyle),
              onTap: () => Get.offAll(HomePage(student: student)),
            ),
            ListTile(
              leading: const Icon(
                Icons.content_copy,
                color: kLightColor,
                size: 30.0,
                semanticLabel: 'Request',
              ),
              title: Text('Request Document', style: titleStyle),
              onTap: () => Get.to(RequestDocuments(student: student)),
            ),
            ListTile(
              leading: const Icon(
                Icons.find_in_page,
                color: kPrimaryColor,
                size: 30.0,
                semanticLabel: 'track',
              ),
              title: Text('Track Document', style: titleStyle),
              onTap: () => {},
            ),
            ListTile(
              leading: const Icon(
                Icons.account_box,
                color: kPrimaryColor,
                size: 30.0,
                semanticLabel: 'profile',
              ),
              title: Text('Profile', style: titleStyle),
              onTap: () => Get.to(const ProfilePage()),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: kPrimaryColor,
                size: 30.0,
                semanticLabel: 'Logout',
              ),
              title: Text('Logout', style: titleStyle),
              onTap: () => Get.offAll(const LoginPage()),
            ),
          ],
        ),
      ),
    );
  }
}
