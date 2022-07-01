import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'home.dart';
import 'register.dart';

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
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Homes()), (route) => false);
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
