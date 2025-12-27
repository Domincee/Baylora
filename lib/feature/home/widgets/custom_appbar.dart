import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values_widget.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/auth/pages/login.dart';
import 'package:baylora_prjct/core/util/uni_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomeAppBar extends StatefulWidget {
  const CustomeAppBar({
    super.key,
    required int currentIndex,
  }) : _currentIndex = currentIndex;

  final int _currentIndex;

  @override
  State<CustomeAppBar> createState() => _CustomeAppBarState();
}

class _CustomeAppBarState extends State<CustomeAppBar> {
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserAvatar();
  }

  Future<void> _fetchUserAvatar() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final data = await Supabase.instance.client
          .from('profiles')
          .select('avatar_url')
          .eq('id', userId)
          .maybeSingle();

      if (data != null && mounted) {
        setState(() {
          _avatarUrl = data['avatar_url'];
        });
      }
    } catch (e) {
      debugPrint('Error fetching avatar: $e');
    }
  }

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
          padding: const EdgeInsets.all(5),
          child: AppBar(
            title: Text(
              widget._currentIndex == 0
                  ? AppStrings.home
                  : widget._currentIndex == 1
                      ? AppStrings.home
                      : AppStrings.profile,
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
                    size: AppValuesWidget.iconDefaultSize,
                    color: Color.fromARGB(255, 0, 0, 0)),
                onPressed: () {},
              ),
              PopupMenuButton<String>(
                offset: const Offset(0, 60),
                // Replaced CircleAvatar with ClipOval + UniversalImage
                icon: ClipOval(
                  child: UniversalImage(
                    path: _avatarUrl ?? Images.defaultAvatar,
                    width: 32, // Adjusted size to fit typical app bar icon size
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                ),
                onSelected: (value) async {
                  if (value == 'my_items') {
                    // Navigate to BottomNav index 2 (Profile)
                  } else if (value == 'settings') {
                    // Push to Settings Page
                  } else if (value == 'logout') {
                    await Supabase.instance.client.auth.signOut();

                    if (context.mounted) {
                      await EasyLoading.show(status: 'Signing out...');

                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false);
                      }

                      // 4. Hide loader
                      EasyLoading.dismiss();
                    }
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
