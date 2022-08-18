import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      // _streamController?.add(null);
      return;
    }
    // var url = Uri.parse(_url + _controller.text.trim());
    //
    // _streamController?.add("waiting");
    // Response response =
    // await get(url, headers: {"Authorization": "Token " + _token});
    // // print(response.body);
    // _streamController?.add(json.decode(response.body));
  }

  TextEditingController _controller = TextEditingController();
  Timer? _debounce;

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: SingleChildScrollView(
                    child: TextFormField(
                      onChanged: (String text) {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 1000), () {
                          trans();
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 2, //grow automatically
                      controller: lang,
                      // controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Search for a word",
                        contentPadding: EdgeInsets.only(left: 24.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  trans();
                  // _search();
                },
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    out.toString(),
                    style: TextStyle(fontSize: 18),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
