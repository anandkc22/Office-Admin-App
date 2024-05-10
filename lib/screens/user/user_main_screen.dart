import 'package:flutter/material.dart';
import 'package:office_administrator_app/constants/colors.dart';
import 'package:office_administrator_app/constants/size.dart';
import 'package:office_administrator_app/screens/user/user_home.dart';
import 'package:office_administrator_app/screens/user/user_messeges.dart';
import 'package:office_administrator_app/screens/user/user_profile.dart';

class UserMainScreen extends StatefulWidget {
  final int index;
  const UserMainScreen({super.key, required this.index});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {

  int _selectedIndex = 0;

  static List <Widget> _widgetOptions = <Widget> [
    UserHomeScreen(),
    UserMessages(),
    UserProfileScreen(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        backgroundColor: Colors.white,
        elevation: 1,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home,
            size: kButtomNavigationBarItemSize,),
            icon: Icon(Icons.home_outlined, 
            size: kButtomNavigationBarItemSize,),
            label: 'Home',
            ),
            BottomNavigationBarItem(
            activeIcon: Icon(Icons.notifications_active,
            size: kButtomNavigationBarItemSize,),
            icon: Icon(Icons.notifications_active_outlined, 
            size: kButtomNavigationBarItemSize,),
            label: 'Messages',
            ),
            BottomNavigationBarItem(
            activeIcon: Icon(Icons.person_2,
            size: kButtomNavigationBarItemSize,),
            icon: Icon(Icons.person_2_outlined, 
            size: kButtomNavigationBarItemSize,),
            label: 'Profile'),
            ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
      ),
    );
  }
}