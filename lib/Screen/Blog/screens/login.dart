import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ivisatrans/api/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Url.dart';
import 'home.dart';
import 'register.dart';
import 'dart:io';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    try {
      final response = await http.post(Uri.parse(Url.loginURL),
          headers: {'Accept': 'application/json'},
          body: {
            'email': encrypt(txtEmail.text),
            'password': encrypt(txtPassword.text)
          });
      switch (response.statusCode) {
        case 200:
          var data = jsonDecode(decrypt(response.body));
          var result = data["data"];
          print(result);
          int success = result[1];
          if (success == 1) {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.setString('username', result[2]["username"] ?? '');
            await pref.setString('email', result[2]["email"] ?? '');
            await pref.setString('phone', result[2]["phone"] ?? '');
            await pref.setInt('userId', result[2]["id"] ?? 0);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Homes()), (
                route) => false);
          } else {
            setState(() {
              loading = false;
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(result[0])));
          }

          break;
        case 422:
          setState(() {
            loading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('server error')));
          break;
        case 403:
          setState(() {
            loading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('server error')));
          break;
        default:
          setState(() {
            loading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('something is wrong')));
          break;
      }
    } on SocketException {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('check internet'),duration: Duration(seconds: 4),));
    } on Exception catch (e) {
      throw Exception(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.greenAccent),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 30.0),
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 5),
                  Image.asset(
                    'assets/playstore.png',
                    height: 80,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Welcome to Intitut-visa",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: txtEmail,
                      validator: (val) =>
                          val!.isEmpty ? 'Invalid email address' : null,
                      decoration: kInputDecoration('Email')),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: txtPassword,
                      obscureText: true,
                      validator: (val) =>
                          val!.length < 6 ? 'Required at least 6 chars' : null,
                      decoration: kInputDecoration('Password')),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          //n'a pas de bordure
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             ForgetPasswordEnterEmailPage()));
                          }, //navigation vers la page forget password
                          child: const Text(
                            "Forget password?",
                            style: TextStyle(color: Colors.redAccent),
                          ))
                    ],
                  ),
                  loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : kTextButton('Login', () {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                              _loginUser();
                            });
                          }
                        }),
                  const SizedBox(
                    height: 20,
                  ),
                  kLoginRegisterHint('Dont have an acount? ', 'Register', () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Register()),
                        (route) => false);
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    BuildingButton(
                      iconImage: const Image(
                        height: 20,
                        width: 20,
                        image: AssetImage('assets/socials/facebook.png'),
                      ),
                      textButton: 'Facebook',
                    ),
                    const SizedBox(width: 10.0),
                    BuildingButton(
                      iconImage: const Image(
                        height: 20,
                        width: 20,
                        image: AssetImage('assets/socials/google.jfif'),
                      ),
                      textButton: 'Google',
                    )
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildingButton extends StatelessWidget {
  final Image iconImage;
  final String textButton;
  BuildingButton({required this.iconImage, required this.textButton});
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * 0.06,
      width: mediaQuery.width * 0.36,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconImage,
          SizedBox(
            width: 5,
          ),
          Text(textButton),
        ],
      ),
    );
  }
}
