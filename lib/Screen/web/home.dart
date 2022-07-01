import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Blog/screens/loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Loading()));
            },
            icon: const Icon(Icons.social_distance),
            color: Colors.amber,
          ),
        ],
      ),
      body: const WebView(
        initialUrl: 'http://www.institut-visa.com',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  // @override
  // void dispose() {
  //   _flutterwebview.dispose();
  //   super.dispose();
  // }
}
