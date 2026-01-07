import 'package:flutter/material.dart';
import 'package:baylora_prjct/core/constant/app_strings.dart';
import 'package:baylora_prjct/core/constant/app_values.dart';
import 'package:baylora_prjct/core/theme/app_colors.dart';
import 'package:baylora_prjct/core/util/network_utils.dart';

class CommonErrorWidget extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;
  final String? customErrorMessage;

  const CommonErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
    this.customErrorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNetworkError = NetworkUtils.isNetworkError(error);

    final String message;
    if (isNetworkError) {
      message = AppStrings.noInternetConnection;
    } else {
      message = customErrorMessage ?? AppStrings.somethingWentWrong;
    }

    final IconData icon = isNetworkError ? Icons.wifi_off : Icons.error_outline;

    return Center(
      child: Padding(
        padding: AppValues.paddingL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.errorColor,
              size: AppValues.iconXL,
            ),
            AppValues.gapM,
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textGrey,
                  ),
            ),
            AppValues.gapM,
            ElevatedButton(
              onPressed: onRetry,
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
