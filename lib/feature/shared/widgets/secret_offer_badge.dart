import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:flutter/material.dart';

import 'constant/shared_widgets_strings.dart';

class SecretOfferBadge extends StatelessWidget {
  const SecretOfferBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(AppValues.radiusCircular),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 16, color: Colors.grey[600]),
          AppValues.gapS,
          Text(
            SharedWidgetString.secretOffer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
          ),
          AppValues.gapS,
          Icon(Icons.lock_outline, size: 16, color: Colors.grey[600]),
        ],
      ),
    );
  }
}
