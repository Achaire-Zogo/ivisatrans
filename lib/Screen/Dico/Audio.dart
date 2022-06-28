import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import '../../api/speech_api.dart';
import '../../utils.dart';

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

  String text = 'Press the button and start speaking';
  bool isListening = false;
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
      floatingActionButton: AvatarGlow(
        animate: true,
        endRadius: 75,
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
          child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
          onPressed: () {},
        ),
      ),
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);

          if (!isListening) {
            Future.delayed(Duration(seconds: 1), () {
              Utils.scanText(text);
            });
          }
        },
      );
}
