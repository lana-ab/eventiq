import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:untitled2/home/HomeScreen.dart';
import 'package:untitled2/mybooking/BookingsScreen.dart';
import 'package:untitled2/profile/ProfileScreen.dart';
import 'package:untitled2/screens/CreateBookingScreen.dart';
import '../search/SearchScreen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState
    extends State<BottomNavigationBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),     // الصفحة الرئيسية
    Search(),         // صفحة البحث
    ProfileScreen(),
    BookingsScreen()
    // صفحة البروفايل
  ];

  final iconList = <IconData>[
    Icons.home,
    Icons.search,

    Icons.person,
    Icons.calendar_today,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBCAEF3),
      body: _pages[_currentIndex],

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 28, color: Color(0xFF4A3C9A)),
        onPressed: () {
          Get.to(() => CreateBookingScreen()); // زر إنشاء فعالية
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Color(0xFFBCAEF3),
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,// الفجوة بالنص
        notchSmoothness: NotchSmoothness.softEdge,
        activeColor: Color(0xFF4A3C9A),
        inactiveColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
