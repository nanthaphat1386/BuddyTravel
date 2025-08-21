import 'package:finalproject/Page/listPlace.page.dart';
import 'package:finalproject/Page/mapPlace.page.dart';
import 'package:finalproject/Page/setting.page.dart';
import 'package:finalproject/Page/timeline.page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class TabBottom extends StatefulWidget {
  const TabBottom({Key? key}) : super(key: key);

  @override
  State<TabBottom> createState() => _TabBottomState();
}

class _TabBottomState extends State<TabBottom> {
  int _currentItem = 0;

  late List<StatefulWidget> Tap = [
    listPlace(),
    mapPlace(),
    timeline(),
    settings()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _currentItem = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Tap.elementAt(_currentItem),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.maps_home_work,color: Colors.grey),
            label: 'รายการสถานที่',
            activeIcon: Icon(Icons.maps_home_work)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public,color: Colors.grey),
            label: 'แผนที่',
            activeIcon: Icon(Icons.public)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline,color: Colors.grey),
            label: 'ไทม์ไลน์',
            activeIcon: Icon(Icons.timeline)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: Colors.grey),
            label: 'ตั้งค่า',
            activeIcon: Icon(Icons.settings)
          ),
        ],
        currentIndex: _currentItem,
        selectedItemColor: HexColor('46BBC7'),
        onTap: _onItemTapped,
      ),
    );
  }
}