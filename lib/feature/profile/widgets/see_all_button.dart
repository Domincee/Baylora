
import 'package:baylora_prjct/feature/profile/constant/profile_strings.dart';
import 'package:flutter/material.dart';

class SeeAllButton extends StatelessWidget {
  final Widget destination;
  const SeeAllButton({
    super.key,
    required this.destination,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ProfileStrings.seeAll,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey, // Replaced AppColors.textGrey
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey, // Replaced AppColors.textGrey
            ),
          ],
        ),
      ),
    );
  }
}