import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/feature/post/widgets/shared/section_header.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController titleController;

  const BasicInfoSection({
    super.key,
    required this.titleController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: "Basic info"),
        AppValues.gapS,
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(hintText: "What are you selling?"),
        ),
      ],
    );
  }
}
