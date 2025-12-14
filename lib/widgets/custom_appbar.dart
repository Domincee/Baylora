import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget {
  const CustomeAppBar({
    super.key,
    required int currentIndex,
  }) : _currentIndex = currentIndex;

  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      title: Text(
        _currentIndex == 0 ? "Home" : 
        _currentIndex == 1 ? "Home" : "Profile",
        
      ),
      centerTitle: true,
      backgroundColor: Colors.blue,
      leading: null,
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {          
        }
         )
       ]
      );
  }
}