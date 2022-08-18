import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:translator/translator.dart';

import '../Blog/models/Dic0Model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "120c36a796e606887e3109364233fcec43eda071";

  TextEditingController _controller = TextEditingController();

  StreamController? _streamController;
  Stream? _stream;
  List<DictionaryModel> _dicoModel = [];

  Timer? _debounce;

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController?.add(null);
      return;
    }
    var url = Uri.parse(_url + _controller.text.trim());

    _streamController?.add("waiting");
    Response response =
        await get(url, headers: {"Authorization": "Token " + _token});
    // print(response.body);
    _streamController?.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();

    _streamController = StreamController();
    _stream = _streamController?.stream;
  }

  GoogleTranslator translator = GoogleTranslator();
  var b = '';
  var c = '';
  String trans(String a) {
    translator.translate(a, to: 'de').then((value) => {
          setState(() {
            c = value
                .text; //placing the translated text to the String to be used
          })
        });
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transvisa"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    onChanged: (String text) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        _search();
                      });
                    },
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Search for a word",
                      contentPadding: EdgeInsets.only(left: 24.0),
                      border: InputBorder.none,
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
                  _search();
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Enter a search word"),
              );
            }

            if (snapshot.data == "waiting") {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            print(snapshot.data.toString());

            return ListView.builder(
              itemCount: snapshot.data["definitions"].length,
              itemBuilder: (BuildContext context, int index) {
                // int i = 0;
                // for (int i = 0; i < index; i++) {
                //  String c =  trans(snapshot.data["definitions"][i]["type"]);
                // }
                // c = trans(snapshot.data["definitions"][index]["type"]);
                // trans(snapshot.data["definitions"][index]["type"]);

                return ListBody(
                  children: <Widget>[
                    Container(
                      color: Colors.grey[300],
                      child: ListTile(
                        leading: snapshot.data["definitions"][index]
                                    ["image_url"] ==
                                null
                            ? null
                            : CircleAvatar(
                                backgroundImage: NetworkImage(snapshot
                                    .data["definitions"][index]["image_url"]),
                              ),
                        title: Text(_controller.text.trim() +
                            "(" +
                            snapshot.data["definitions"][index]["type"] +
                            ")"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        translateDialog(
                            _controller.text.trim(),
                            snapshot.data["definitions"][index]["type"]
                                .toString(),
                            snapshot.data["definitions"][index]["definition"]
                                .toString());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            snapshot.data["definitions"][index]["definition"]),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future translateDialog(String world, String type, String a) => showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
          child: AlertDialog(
              title: Text(trans(world)),
              content: Text("(" + trans(type) + ")\n" + trans(a)),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("cancel"),
                ),
              ]),
        ),
      );

  _dataHistoricBluetoothList() {
    return ListView.builder(
      itemCount: _dicoModel.length,
      // itemCount: 2,
      itemBuilder: (BuildContext context, index) {
        final dico = _dicoModel[index];
        return ListBody(
          children: <Widget>[
            Container(
              color: Colors.grey[300],
              child: ListTile(
                leading: dico.definitions[0].imageUrl == null
                    ? null
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(dico.definitions[0].imageUrl),
                      ),
                title: Text(_controller.text.trim() +
                    "(" +
                    dico.definitions[0].type +
                    ")"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(dico.definitions[0].definition),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(dico.definitions[0].example),
            )
          ],
        );

        // return Card(
        //   color: Colors.lightBlue[100],
        //   elevation: 10.0,
        //   child: ListTile(
        //     title: Text(dico.word),
        //     subtitle: Text(dico.pronunciation),
        //     leading: Icon(
        //       Icons.bluetooth_audio,
        //       color: Colors.blue,
        //     ),
        //     onTap: () {
        //     },
        //   ),
        // );
      },
    );
  }

  // @override
  // void dispose() {
  //   _flutterwebview.dispose();
  //   super.dispose();
  // }
}
