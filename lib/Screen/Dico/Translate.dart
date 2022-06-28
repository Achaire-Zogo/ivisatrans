import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'Audio.dart';

class Translate extends StatefulWidget {
  const Translate({Key? key}) : super(key: key);

  @override
  _TranslateState createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  GoogleTranslator translator = GoogleTranslator(); //using google translator

  String? out;
  final lang = TextEditingController(); //getting text

  void trans() {
    translator.translate(lang.text, to: 'de') //translating to hi = hindi
        .then((output) {
      setState(() {
        out =
            output.text; //placing the translated text to the String to be used
      });
      print(out);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Column(
          children: <Widget>[
            TextField(
              controller: lang,
            ),
            RaisedButton(
              color: Colors.red,
              child: const Text(
                  "Press !!"), //on press to translate the language using function
              onPressed: () {
                trans();
              },
            ),
            RaisedButton(
              color: Colors.red,
              child: const Text(
                  'audio'), //on press to translate the language using function
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Audio()));
              },
            ),
            Text(out.toString()) //translated string
          ],
        )),
      ),
    );
  }
}
