import 'package:flutter/material.dart';
import 'package:musica/palettes/ColorPalettes.dart';
import 'package:musica/screens/ScreenHomeList.dart';
import 'package:musica/screens/ScreenSettings.dart';

import 'ScreenPlaylist.dart';

class ScreenNavigation extends StatefulWidget {
  const ScreenNavigation({super.key});

  @override
  State<ScreenNavigation> createState() => ScreenNavigationState();
}

class ScreenNavigationState extends State<ScreenNavigation> {
  
  final _bottomNavBar = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.queue_music), label: 'Playlist'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  final List<Widget> _screens = <Widget>[
    const ScreenHomeList(),
    const ScreenPlaylist(),
    const ScreenSettings(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
          child: _screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        currentIndex: _selectedIndex,
        elevation: 0,
        backgroundColor: kBottomBackgroundColor,
        iconSize: 30,
        selectedItemColor: kPink,
        unselectedItemColor: kBottomIconColor,
        items: _bottomNavBar,
      ),
    );
  }
}
