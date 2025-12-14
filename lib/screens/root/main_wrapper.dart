import 'package:baylora_prjct/constant/app_strings.dart';
import 'package:baylora_prjct/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // 1. Define your pages here
  final List<Widget> _pages = [
    const HomeScreen(),
    const SizedBox(), // Placeholder for Post (Index 1)
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CustomeAppBar(currentIndex: _currentIndex),
      ),

      body: 
      IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF8B5CF6), 
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          
          if (index == 1) {
         
            Navigator.pushNamed(context, '/create_listing');
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),

            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 32),
          
            label: AppStrings.post, 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),

            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
