import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ivisatrans/Screen/Dico/Audio.dart';

import 'Dico/Translate.dart';
import 'web/home.dart';

class HomePageAll extends StatefulWidget {
  const HomePageAll();
  @override
  _HomePageAllState createState() => _HomePageAllState();
}

class _HomePageAllState extends State<HomePageAll> {
  List<Widget> tabs = [];

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      const Home(),
      const Translate(),
      Audio(),
      // //TabScreen2(user: widget.user),
      // TabScreen4(user: widget.user),
    ];
  }

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // drawer: NavDrawer(),
        body: tabs[currentTabIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTapped,
          currentIndex: currentTabIndex,
          //backgroundColor: Colors.blueGrey,
          type: BottomNavigationBarType.fixed,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
              ),
              label: "Dico",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.record_voice_over,
              ),
              label: "Audio",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Social",
            ),
          ],
        ),
      );
}
