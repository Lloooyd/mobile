import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/common/constant.dart';
import 'package:mobile/login.dart';
import 'package:mobile/pages/request.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: true,
  //   sound: true,
  // );

  
  
// if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//   print('User granted permission');
// } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//   print('User granted provisional permission');
// } else {
//   print('User declined or has not accepted permission');
// }
  // print('User granted permission: ${settings.authorizationStatus}');
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!),
      title: 'iRequest',
      theme: ThemeData(
          scaffoldBackgroundColor: kPrimaryColor,
          primaryColor: Colors.white,
          textTheme: GoogleFonts.openSansTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      // home: const LoginPage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/requestpage': (context) => const RequestPage()
      }
    );
  }
}
