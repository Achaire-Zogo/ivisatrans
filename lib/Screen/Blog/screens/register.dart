import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/encrypt.dart';
import '../Url.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'home.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  void _registerUser() async {
    try {
      final response = await http.post(Uri.parse(Url.registerURL),
          headers: {'Accept': 'application/json'},
          body: {
            'username': encrypt(nameController.text),
            'email': encrypt(emailController.text),
            'phone': encrypt(phoneController.text),
            'password': encrypt(passwordController.text)
          });
      switch (response.statusCode) {
        case 200:
          var data = jsonDecode(decrypt(response.body));
          var result = data["data"];
          print(result);
          int success = result[1];
          if (success == 1) {
            setState(() {
              loading = false;
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("success")));

            // SharedPreferences pref = await SharedPreferences.getInstance();
            // await pref.setString('username', result[2]["username"] ?? '');
            // await pref.setString('email', result[2]["email"] ?? '');
            // await pref.setString('phone', result[2]["phone"] ?? '');
            // await pref.setInt('userId', result[2]["id"] ?? 0);
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (context) => Homes()), (
            //     route) => false);
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
    }on SocketException catch(e){
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('check internet'),duration: Duration(seconds: 4),));
    }on Exception catch (e) {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('something wrong')));
      throw Exception(e);
    }

  }

  // Save and redirect to home
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
          'Register',
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
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 5),
                  Image.asset(
                    'assets/playstore.png',
                    height: 80,
                  ),
                  TextFormField(
                      controller: nameController,
                      validator: (val) => val!.isEmpty ? 'Invalid name' : null,
                      decoration: kInputDecoration('Name')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          val!.isEmpty ? 'Invalid email address' : null,
                      decoration: kInputDecoration('Email')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          val!.isEmpty ? 'Invalid phone number' : null,
                      decoration: kInputDecoration('Phone')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (val) =>
                          val!.length < 6 ? 'Required at least 6 chars' : null,
                      decoration: kInputDecoration('Password')),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: passwordConfirmController,
                      obscureText: true,
                      validator: (val) => val != passwordController.text
                          ? 'Confirm password does not match'
                          : null,
                      decoration: kInputDecoration('Confirm password')),
                  const SizedBox(
                    height: 20,
                  ),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : kTextButton(
                          'Register',
                          () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                loading = !loading;
                                _registerUser();
                              });
                            }
                          },
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  kLoginRegisterHint('Already have an account? ', 'Login', () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
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
