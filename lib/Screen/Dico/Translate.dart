import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class Translate extends StatefulWidget {
  const Translate({Key? key}) : super(key: key);

  @override
  _TranslateState createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  GoogleTranslator translator = GoogleTranslator(); //using google translator
  final FlutterTts flutterTts = FlutterTts();

  speak(String te) async {
    await flutterTts.setLanguage("de");
    await flutterTts.setPitch(0.5);
    await flutterTts.speak(te);
  }

  String out = '';
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
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              speak(out);
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
              await FlutterClipboard.copy(out);
              Scaffold.of(context).showSnackBar(
                const SnackBar(content: Text('✓   Copied to Clipboard')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              height: 200,
              color: Colors.grey,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null, //grow automatically
                    controller: lang,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.red,
              child: const Text(
                  "Translate !!"), //on press to translate the language using function
              onPressed: () {
                trans();
              },
            ),
            Container(
              padding: const EdgeInsets.all(7.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, child: Text(out.toString())),
            ),
          ],
        ),
      ),
    );
  }
}
