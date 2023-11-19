import 'package:flutter/material.dart';

import 'package:crypto_login_register/pages/login.dart';
import 'package:crypto_login_register/pages/dashboard.dart';
import 'package:crypto_login_register/pages/register.dart';
import 'package:crypto_login_register/component/authentication/check_registration.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    RegistrationService.checkRegistrationStatus((bool status) {
      setState(() {
        isRegistered = status;
        print(isRegistered);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;

    if (isRegistered) {
      homeWidget = LoginPage();
    } else {
      homeWidget = RegisterPage();
    }

    return MaterialApp(
      title: 'Login Register',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: homeWidget,
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
      },
    );
  }
}
