import 'package:flutter/material.dart';

import 'constant/shared_widgets_strings.dart';

class SwapItemsWrap extends StatelessWidget {
  final String? swapItemString;

  const SwapItemsWrap({super.key, this.swapItemString});

  @override
  Widget build(BuildContext context) {
    if (swapItemString == null || swapItemString!.trim().isEmpty) {
      return _buildPill(context, SharedWidgetString.openToAnyOffers);
    }

    final items = swapItemString!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    if (items.isEmpty) {
      return _buildPill(context, SharedWidgetString.openToAnyOffers);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) => _buildPill(context, item)).toList(),
    );
  }

  Widget _buildPill(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.cyan[50], // Light Cyan background
        borderRadius: BorderRadius.circular(20), // Stadium border
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.cyan[800], // Dark Cyan text
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
