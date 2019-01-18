import 'package:flutter/material.dart';
import 'home.dart';

class MyNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyNavigatorState();
}

class _MyNavigatorState extends State<MyNavigator> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Home(),
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              _buildBottomNavigationBarItem(Icons.home, ""),
              _buildBottomNavigationBarItem(Icons.queue_music, "")
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String text) {
    return BottomNavigationBarItem(
      activeIcon: Icon(
        icon,
        color: Colors.black,
        size: 25.0,
      ),
      icon: Icon(
        icon,
        color: Colors.grey,
        size: 25.0,
      ),
      title: Text(text),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
