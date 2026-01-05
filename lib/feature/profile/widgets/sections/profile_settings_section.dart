import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:baylora_prjct/feature/profile/widgets/settings_tile.dart';

class ProfileSettingsSection extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;

  const ProfileSettingsSection({
    super.key,
    required this.onEditProfile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Settings Header (Outside) ---
        Text(
          ProfileStrings.settings,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppValues.gapXXS,
        Text(
          ProfileStrings.settingsSubtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textGrey,
          ),
        ),
        AppValues.gapM,

        // --- Grouped Card Container ---
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppValues.borderRadiusCircular,
            border: Border.all(color: Colors.grey.shade200),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Item 1: Edit Profile
              SettingsTile(
                title: ProfileStrings.editProfile,
                subtitle: ProfileStrings.editProfileSubtitle,
                onTap: onEditProfile,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              
              // Item 2: Notification
              const SettingsTile(
                title: ProfileStrings.notifications,
                subtitle: ProfileStrings.notificationSubtitle,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              
              // Item 3: Privacy & Terms
              const SettingsTile(
                title: ProfileStrings.privacyTerms,
                subtitle: ProfileStrings.privacyTermsSubtitle,
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),

              // Item 4: Log out
              SettingsTile(
                title: ProfileStrings.logout,
                hideSubtitle: true,
                onTap: onLogout,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
