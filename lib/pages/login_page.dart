import 'package:project40_mobile_app/global_vars.dart' as global;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project40_mobile_app/apis/user_api.dart';
import 'package:project40_mobile_app/models/user.dart';
import 'package:project40_mobile_app/pages/home.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(10.0)),
            _loginForm(),
          ],
        ),
      ),
    );
  }

  _loginForm() {
    return Column(
      children: <Widget>[
        const Text("Email"),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        const Text("Password"),
        TextField(
          controller: passwordController,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        ElevatedButton(
          onPressed: _login,
          child: const Text(
            "Login",
            style: TextStyle(
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
    });
  }
}
