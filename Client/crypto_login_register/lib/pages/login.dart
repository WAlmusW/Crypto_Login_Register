import 'package:flutter/material.dart';

import 'package:crypto_login_register/component/authentication/login_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _username;
  late final TextEditingController _password;

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _username,
                decoration: InputDecoration(
                  hintText: "Enter your username here",
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.email),
                ),
                enableSuggestions: false,
                autocorrect: false,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  hintText: "Enter your password here",
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () async {
                  final username = _username.text;
                  final password = _password.text;

                  try {
                    print(username + " " + password);
                    LoginService.loginUser(username, password, (isLoggedIn) {
                      if (isLoggedIn) {
                        print('Login successful $isLoggedIn');
                        Navigator.pushNamed(context, '/dashboard');
                      } else {
                        print(
                            'Login failed. Check your username and password.');
                      }
                    });
                  } catch (e) {
                    print("Login failed. Check your username and password");
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
