import 'package:baylora_prjct/assets/images.dart';
import 'package:baylora_prjct/constant/app_sizes_widget.dart';
import 'package:baylora_prjct/constant/app_strings.dart';
import 'package:baylora_prjct/theme/app_colors.dart';
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
                
                color: AppColors.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor, // 👈 shadow color
                    blurRadius: 2,
                    spreadRadius: -2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizesWidget.appbarHorPad,                 
                vertical: AppSizesWidget.appbarVertPad
                ),
                child: AppBar(
                   title: Text(
                        _currentIndex == 0 ? AppStrings.home : 
                        _currentIndex == 1 ?  AppStrings.home  :  AppStrings.profile,
                        style: Theme.of(context).textTheme.titleSmall!,
                        
                      ),
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: Padding(
                        padding: AppSizesWidget.logoPadding,
                        child: SvgPicture.asset(Images.logo),
                      ),
                
                
                      actions: [
                         IconButton(
                          icon: const Icon(Icons.notifications_outlined, 
                          size: AppSizesWidget.iconDefaultSize, color:
                           Color.fromARGB(255, 0, 0, 0)),
                          onPressed: () {},
                        ),
                        IconButton(onPressed: (){}, icon: CircleAvatar()),
                       
                      ],
                ),
              ),
            ),
          );
  }
}