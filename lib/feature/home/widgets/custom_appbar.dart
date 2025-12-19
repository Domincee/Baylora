import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomeAppBar extends StatelessWidget {
  const CustomeAppBar({
    super.key,
    required int currentIndex,
  }) : _currentIndex = currentIndex;

  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
           
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor, 
                    blurRadius: 2,
                    spreadRadius: -2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Container(
                color: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: AppValuesWidget.appbarHorPad,                 
                  vertical: AppValuesWidget.appbarVertPad
                  ),
                  child: AppBar(
                    title: Text(
                          _currentIndex == 0 ? AppStrings.home : 
                          _currentIndex == 1 ?  AppStrings.home  :  AppStrings.profile,
                          style: Theme.of(context).textTheme.titleSmall!,
                          
                        ),
                        centerTitle: true,
                        backgroundColor: AppColors.primaryColor,
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        scrolledUnderElevation: 0,
                        leading: Padding(
                          padding: AppValuesWidget.logoPadding,
                          child: SvgPicture.asset(Images.logo),
                        ),
                  
                  
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, 
                            size: AppValuesWidget.iconDefaultSize, color:
                            Color.fromARGB(255, 0, 0, 0)),
                            onPressed: () {},
                          ),
                          
                        PopupMenuButton<String>(
                          offset: const Offset(0, 60),
                              icon: CircleAvatar(
                                // user photo
                                backgroundImage: NetworkImage(Images.defaultAvatar), 
                              ),
                              onSelected: (value) {
                                if (value == 'my_items') {
                                  // Navigate to BottomNav index 2 (Profile)
                                } else if (value == 'settings') {
                                  // Push to Settings Page
                                } else if (value == 'logout') {
                                  // Call Supabase Logout function
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  const PopupMenuItem(
                                    value: 'my_items',
                                    child: Text('My Items'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'settings',
                                    child: Text('Settings'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'logout',
                                    child: Text('Logout', style: TextStyle(color: Colors.red)),
                                  ),
                                ];
                              },
          ),               
                        ],
                  ),
                ),
              ),
            );
  }
}