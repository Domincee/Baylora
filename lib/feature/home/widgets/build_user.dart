import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:baylora_prjct/core/assets/images.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';

class BuildUser extends StatelessWidget {
  const BuildUser({
    super.key,
    required this.sellerName,
    required this.isVerified,
    required this.postedTime,
  });

  final String sellerName;
  final bool isVerified;
  final String postedTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "@$sellerName",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: AppColors.black,
              ),
            ),
            if (isVerified) ...[
              AppValues.gapHXXS,
              SvgPicture.asset(
                Images.statusVerified,
                width: AppValues.avatarSizeSmall.width,
                height: AppValues.avatarSizeSmall.height,
              ),
            ],
          ],
        ),
        Text(
          postedTime,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: AppColors.subTextColor,
          ),
        ),
      ],
    );
  }
}
