import 'package:flutter/material.dart';

/// Standardized spacing, sizing, and timing constants for the entire app.
/// All values follow an 8px grid system for consistency.
class AppValues {
  // ============================================
  // SPACING - Padding & Margins (8px grid)
  // ============================================
  
  /// 5px spacing
  static const double spacing5 = 5.0;

  /// Extra small spacing - 8px
  static const double spacingXS = 8.0;
  
  /// 10px spacing - (Custom)
  static const double spacing10 = 10.0;
  
  /// Small spacing - 12px
  static const double spacingS = 12.0;
  
  /// Medium spacing - 16px
  static const double spacingM = 16.0;
  
  /// 20px spacing - (Custom)
  static const double spacing20 = 20.0;
  
  /// Large spacing - 24px
  static const double spacingL = 24.0;
  
  /// Extra large spacing - 32px
  static const double spacingXL = 32.0;
  
  /// XXL spacing - 40px
  static const double spacingXXL = 40.0;

  // ============================================
  // EDGE INSETS - Common padding patterns
  // ============================================
  
  /// Horizontal padding - 16px left/right
  static const EdgeInsets paddingH = EdgeInsets.symmetric(horizontal: spacingM);
  
  /// Vertical padding - 16px top/bottom
  /// All sides - 16px
  static const EdgeInsets paddingAll = EdgeInsets.all(spacingM);
  
  /// All sides - 12px
  static const EdgeInsets paddingS = EdgeInsets.all(spacingS);
  
  /// Screen padding - 20px horizontal, 16px vertical
  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: spacingM,
  );
  
  /// Card padding - 16px all sides
  static const EdgeInsets paddingCard = EdgeInsets.all(spacingM);
  
  /// Small padding - 8px all sides
  static const EdgeInsets paddingSmall = EdgeInsets.all(spacingXS);
  
  /// Large padding - 24px all sides
  static const EdgeInsets paddingLarge = EdgeInsets.all(spacingL);

  // ============================================
  // GAPS - Vertical spacing widgets
  // ============================================
  
  /// 4px gap
  static const Widget gapXXS = SizedBox(height: 4.0);
  
  /// 8px gap
  static const Widget gapXS = SizedBox(height: spacingXS);
  
  /// 10px gap
  static const Widget gap10 = SizedBox(height: spacing10);
  
  /// 12px gap
  static const Widget gapS = SizedBox(height: spacingS);
  
  /// 16px gap
  static const Widget gapM = SizedBox(height: spacingM);
  
  /// 20px gap
  static const Widget gap20 = SizedBox(height: spacing20);
  
  /// 24px gap
  static const Widget gapL = SizedBox(height: spacingL);
  
  /// 32px gap
  static const Widget gapXL = SizedBox(height: spacingXL);
  
  /// 40px gap
  static const Widget gapXXL = SizedBox(height: spacingXXL);

  // ============================================
  // HORIZONTAL GAPS
  // ============================================
  
  /// 4px horizontal gap
  static const Widget gapHXXS = SizedBox(width: 4.0);
  
  /// 8px horizontal gap
  static const Widget gapHXS = SizedBox(width: spacingXS);
  
  /// 12px horizontal gap
  static const Widget gapHS = SizedBox(width: spacingS);
  
  /// 16px horizontal gap
  static const Widget gapHM = SizedBox(width: spacingM);
  
  /// 24px horizontal gap
  static const Widget gapHL = SizedBox(width: spacingL);

  // ============================================
  // BORDER RADIUS
  // ============================================
  
  /// Small radius - 8px
  static const double radiusS = 8.0;
  
  /// Medium radius - 12px
  static const double radiusM = 12.0;
  
  /// Large radius - 16px
  static const double radiusL = 16.0;
  
  /// Extra large radius - 20px
  static const double radiusXL = 20.0;
  
  /// Circular/pill radius - 30px
  static const double radiusCircular = 30.0;

  /// Small border radius
  static BorderRadius borderRadiusS = BorderRadius.circular(radiusS);
  
  /// Medium border radius
  static BorderRadius borderRadiusM = BorderRadius.circular(radiusM);
  
  /// Large border radius
  static BorderRadius borderRadiusL = BorderRadius.circular(radiusL);
  
  /// Extra large border radius
  static BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);
  
  /// Circular border radius
  static BorderRadius borderRadiusCircular = BorderRadius.circular(radiusCircular);

  // ============================================
  // ICON SIZES
  // ============================================
  
  /// Small icon - 16px
  static const double iconS = 16.0;
  
  /// Medium icon - 24px
  static const double iconM = 24.0;
  
  /// Large icon - 32px
  static const double iconL = 32.0;
  
  /// Extra large icon - 48px
  static const double iconXL = 48.0;

  // ============================================
  // COMPONENT SIZES
  // ============================================
  
  /// Loading indicator size
  static const double loadingIndicatorSize = 20.0;

  /// Avatar size - 14px (small badge/verification)
  static const Size avatarSizeSmall = Size(14, 14);
  
  /// Avatar size - 32px (list item)
  static const Size avatarSizeMedium = Size(32, 32);
  
  /// Avatar size - 48px (profile)
  static const Size avatarSizeLarge = Size(48, 48);

  /// Avatar Radius Profile - 35px (70px dia)
  static const double avatarRadiusProfile = 35.0;
  
  /// Search bar height
  static const double searchBarHeight = 50.0;
  
  /// Input field height
  static const double inputHeight = 56.0;
  
  /// Button height
  static const double buttonHeight = 48.0;

  // ============================================
  // ANIMATION DURATIONS (milliseconds)
  // ============================================
  
  /// Fast animation - 150ms
  static const int durationFast = 150;
  
  /// Normal animation - 300ms
  static const int durationNormal = 300;
  
  /// Slow animation - 500ms
  static const int durationSlow = 500;

  // ============================================
  // GRID SYSTEM
  // ============================================
  
  /// Grid spacing for lists/grids - 15px
  static const double gridSpacing = 15.0;
  
  /// Grid item aspect ratio for cards
  static const double gridAspectRatio = 0.8;
  
  /// Max width for content cards
  static const double maxContentWidth = 500.0;

  // ============================================
  // ELEVATION & SHADOWS
  // ============================================
  
  /// Low elevation
  static const double elevationLow = 2.0;
  
  /// Medium elevation
  static const double elevationMedium = 4.0;
  
  /// High elevation
  static const double elevationHigh = 8.0;
}
