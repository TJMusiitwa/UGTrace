import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:ug_covid_trace/ui/home/home_screen.dart';
import 'package:ug_covid_trace/ui/notify/notify_screen.dart';
import 'package:ug_covid_trace/ui/settings/settings_screen.dart';

class TraceNav extends StatefulWidget {
  @override
  _TraceNavState createState() => _TraceNavState();
}

class _TraceNavState extends State<TraceNav> {
  int _currentPage = 0;

  var pages = [
    HomeScreen(),
    NotifyScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: SafeArea(
        child: pages.elementAt(_currentPage),
      ),
      bottomNavBar: PlatformNavBar(
          currentIndex: _currentPage,
          items: [
            BottomNavigationBarItem(
              icon: Icon(context.platformIcons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(context.platformIcons.flag),
              title: Text('Notify Others'),
            ),
            BottomNavigationBarItem(
              icon: Icon(context.platformIcons.settings),
              title: Text('Settings'),
            ),
          ],
          itemChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          }),
    );
  }
}
