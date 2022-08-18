import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

import '../../utils.dart';
import '../../widget/substring_highlighted.dart';

class Audio extends StatefulWidget {
  @override
  _AudioState createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  var _speech = stt.SpeechToText();
  String text = 'Press the button and start speaking';
  bool isListening = false;
  GoogleTranslator translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();

  speak(String te) async {
    await flutterTts.setLanguage("de");
    await flutterTts.setPitch(0.5);
    await flutterTts.speak(te);
  }

  void trans() {
    translator.translate(text, to: 'de') //translating to hi = hindi
        .then((output) {
      setState(() {
        text =
            output.text; //placing the translated text to the String to be used
      });
      print(text);
    });
  }

  void onListen() async {
    if (!isListening) {
      bool available = await _speech.initialize(
          onStatus: (status) => print("This is status" + "$status"),
          onError: (errorNotification) => print("$errorNotification"));
      if (available) {
        setState(() {
          isListening = true;
        });
        _speech.listen(
          onResult: (result) => setState(() {
            text = result.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        isListening = false;
      });
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(''),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                speak(text);
              },
              icon: const Icon(Icons.play_arrow),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                // setState(() {
                //   text = 'translating...';
                // });
                trans();
              },
              icon: const Icon(Icons.book),
              color: Colors.green,
            ),
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () async {
                await FlutterClipboard.copy(text);
                Scaffold.of(context).showSnackBar(
                  const SnackBar(content: Text('✓   Copied to Clipboard')),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(30).copyWith(bottom: 150),
          child: SubstringHighlight(
            text: text,
            terms: Command.all,
            textStyle: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            textStyleHighlight: const TextStyle(
              fontSize: 32.0,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: isListening,
          endRadius: 75,
          glowColor: Theme.of(context).primaryColor,
          child: FloatingActionButton(
            child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
            onPressed: onListen,
          ),
        ),
      );
}
