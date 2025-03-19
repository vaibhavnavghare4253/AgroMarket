import 'package:flutter/material.dart';

import '../home_screen/home_screen.dart';
import '../my_profile/my_profile.dart';
import '../review_cart/review_cart.dart';
import '../wish_list/wish_list.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    HomeScreen(),
    WishList(),
    ReviewCart(),
    MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Main Content (Pages)
          Positioned.fill(
            bottom: 40, // Keeps the content above the navbar
            child: PageView(
              controller: _pageController,
              children: _screens,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),

          /// Static Curved Navigation Bar with Gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Curved edges
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.lightGreenAccent], // Gradient color
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  navBarItem(Icons.home, 0),
                  navBarItem(Icons.favorite, 1),
                  navBarItem(Icons.shopping_cart, 2),
                  navBarItem(Icons.person, 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Function to Build Each Navbar Item
  Widget navBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        _pageController.jumpToPage(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: _currentIndex == index ? 35 : 30, // Slight increase in selected icon size
            color: _currentIndex == index ? Colors.white : Colors.black54,
          ),
        ],
      ),
    );
  }
}
