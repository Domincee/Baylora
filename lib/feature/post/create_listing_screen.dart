import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  // Step 1: Selected Type (0: Sell, 1: Trade, 2: Sell or Trade)
  // Default to -1 (none selected)
  int _currentStep = 0;
  int _selectedType = -1;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppValues.spacingM),
            child: TextButton(
              onPressed: _selectedType != -1 
                  ? () {
                    setState(() {
                     _currentStep += 1;

                    });
                    } 
                  : null, // Disabled if no type selected
              child: Text(
                "Next",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: _selectedType != -1 ? AppColors.royalBlue : Colors.grey,
                )
                
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: AppValues.paddingH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What type of listing is this?",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            AppValues.gapXS,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Choose the best option for your item.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
                Text("$_currentStep/3",
                 style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: AppColors.subTextColor
                 ),),
              ],
            ),
            AppValues.gapL,

            _buildOptionCard(
              index: 0,
              title: "Sell Item",
              subtitle: "For cash transactions only",
              icon: Icons.attach_money,
            ),
            AppValues.gapM,
            _buildOptionCard(
              index: 1,
              title: "Trade Item",
              subtitle: "Exchange items with others",
              icon: Icons.swap_horiz,
            ),
            AppValues.gapM,
            _buildOptionCard(
              index: 2,
              title: "Sell or Trade",
              subtitle: "Open to both cash and trades (Recommended)",
              icon: Icons.handshake_outlined, // Or Icons.check_circle_outline
              isRecommended: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    bool isRecommended = false,
  }) {
    final isSelected = _selectedType == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = index;
        });
      },
      child: Container(
        padding: AppValues.paddingCard,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.royalBlue.withValues(alpha: 0.05) : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.royalBlue : AppColors.greyMedium,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: AppValues.borderRadiusM,
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: AppValues.paddingSmall,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.royalBlue : AppColors.greyLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.textDarkGrey,
                size: AppValues.iconM,
              ),
            ),
            AppValues.gapHM,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isSelected ? AppColors.royalBlue : AppColors.black,
                        ),
                      ),
                      if (isRecommended) ...[
                        AppValues.gapHXS,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.recommendedColor.withValues(alpha: 0.1),
                            borderRadius: AppValues.borderRadiusS,
                          ),
                          child: Text(
                            "Recommended",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.recommendedColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  AppValues.gapXXS,
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textDarkGrey,
                    ),
                  ),
                ],
              ),
            ),

            // Radio Indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.royalBlue : AppColors.greyDisabled,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.royalBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
