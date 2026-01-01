import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

class DescriptionSection extends StatelessWidget {
  final TextEditingController descriptionController;

  const DescriptionSection({
    super.key,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Description & Details"),
        AppValues.gapS,
        TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(
            hintText:
                "Describe the item, its condition and what buyers should know...",
          ),
          maxLines: 5,
        ),
      ],
    );
  }
}
