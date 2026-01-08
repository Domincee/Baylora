import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../../details/provider/item_details_provider.dart';
import '../constant/manage_listing_strings.dart';
import '../widgets/manage_dashboard_body.dart';
import '../widgets/manage_listing_fab.dart';

class ManageListingScreen extends ConsumerWidget {
  final String itemId;

  const ManageListingScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(itemDetailsProvider(itemId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(ManageListingStrings.manageListingTitle, style: AppTextStyles.titleSmall(context)),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: itemAsync.when(
        data: (item) => ManageListingFab(item: item),
        loading: () => null,
        error: (_, _) => null,
      ),
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("${ManageListingStrings.errorPrefix}$err")),
        data: (item) => ManageDashboardBody(item: item, ref: ref),
      ),
    );
  }
}