import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/feature/home/home_screen.dart';
import 'package:baylora_prjct/feature/home/widgets/primary_app_bar.dart';
import 'package:baylora_prjct/feature/profile/profile_screen.dart';

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
        preferredSize: const Size.fromHeight(60.0),
        child: PrimaryAppBar(currentIndex: _currentIndex),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.royalBlue,
          unselectedItemColor: AppColors.textGrey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: Theme.of(context).textTheme.labelSmall,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushNamed(context, '/create_listing');
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.home_outlined, size: 26),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.home, size: 26),
              ),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.royalBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 24),
              ),
              label: AppStrings.post,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.person_outline, size: 26),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(Icons.person, size: 26),
              ),
              label: AppStrings.profile,
            ),
          ],
        ),
      ),
    );
  }
}
