import 'package:localization/src/localization_extension.dart';
import 'package:project40_mobile_app/global_vars.dart' as global;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project40_mobile_app/apis/user_api.dart';
import 'package:project40_mobile_app/models/user.dart';
import 'package:project40_mobile_app/pages/home.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User user = User(
      id: 0,
      name: "",
      password: "",
      email: "",
      address: "",
      zipCode: "",
      hometown: "",
      createdAt: "",
      token: "");
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var message = 'login-connected_msg'.i18n();
  bool connected = true;
  var errorMessage;

  @override
  initState() {
    super.initState();
    var subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          message = 'login-not_connected_msg'.i18n();
          connected = false;
        });
      } else {
        setState(() {
          message = 'login-connected_msg'.i18n();
          connected = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('login-login_text'.i18n())),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(10.0)),
            _loginForm(),
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            _connectionMessage()
          ],
        ),
      ),
    );
  }

  _loginForm() {
    return Column(
      children: <Widget>[
        Text('login-email_text'.i18n()),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'login-email_text'.i18n(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        Text('login-password_text'.i18n()),
        TextField(
          controller: passwordController,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'login-password_text'.i18n(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        ElevatedButton(
          onPressed: connected ? _login : null,
          child: Text(
            'login-login_text'.i18n(),
            style: const TextStyle(
              fontSize: 20.0,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal,
            ),
          ),
          style: ElevatedButton.styleFrom(
              minimumSize:
                  const Size(30, 50) // put the width and height you want
              ),
        ),
      ],
    );
  }

  void _login() {
    user.password = passwordController.text;
    user.email = emailController.text;

    UserApi.loginUser(user).then((result) {
      user = result;

      global.userId = user.id;
      global.userToken = user.token;

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[400], content: Text(error.toString())));
    });
  }

  _connectionMessage() {
    if (!connected) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.red[200],
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.green[200],
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      );
    }
  }
}
