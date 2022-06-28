import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
