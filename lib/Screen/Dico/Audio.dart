import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class Audio extends StatefulWidget {
  const Audio({Key? key}) : super(key: key);

  @override
  _AudioState createState() => _AudioState();
}

class _AudioState extends State<Audio> {
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

  String text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all((30)),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 32.0, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.mic_none,
          size: 36,
        ),
        onPressed: () {},
      ),
    );
  }
}
