import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UsernameWithBadge extends StatelessWidget {
  final String username;
  final bool isVerified;
  final TextStyle? style;
  final MainAxisAlignment mainAxisAlignment;

  const UsernameWithBadge({
    super.key,
    required this.username,
    required this.isVerified,
    this.style,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Flexible(
          child: Text(
            username.startsWith("@") ? username : "@$username",
            style: style ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isVerified) ...[
          AppValues.gapHXXS,
          const Icon(
            Icons.verified,
            size: 16,
            color: AppColors.blueText,
          ),
        ],
      ],
    );
  }
}
