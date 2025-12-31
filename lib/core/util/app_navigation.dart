import 'package:flutter/material.dart';

/// Centralized navigation patterns and route builders.
/// Ensures consistent transitions across the application.
class AppNavigation {
  AppNavigation._(); // Private constructor - static utility only

  /// Fade transition route - smooth opacity change
  static PageRoute<T> fadeRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Slide transition route - slides in from right
  static PageRoute<T> slideRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Scale transition route - scales up from center
  static PageRoute<T> scaleRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Standard material route (no custom transition)
  static PageRoute<T> materialRoute<T>(Widget page) {
    return MaterialPageRoute<T>(builder: (context) => page);
  }

  /// Pushes a route and replaces current route
  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget page, {
    RouteType routeType = RouteType.fade,
  }) {
    final PageRoute<T> route = switch (routeType) {
      RouteType.fade => fadeRoute<T>(page),
      RouteType.slide => slideRoute<T>(page),
      RouteType.scale => scaleRoute<T>(page),
      RouteType.material => materialRoute<T>(page),
    };

    return Navigator.of(context).pushReplacement<T, TO>(route);
  }

  /// Pushes a new route on top of current route
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    Widget page, {
    RouteType routeType = RouteType.fade,
  }) {
    final PageRoute<T> route = switch (routeType) {
      RouteType.fade => fadeRoute<T>(page),
      RouteType.slide => slideRoute<T>(page),
      RouteType.scale => scaleRoute<T>(page),
      RouteType.material => materialRoute<T>(page),
    };

    return Navigator.of(context).push<T>(route);
  }
}

/// Enum for different route transition types
enum RouteType {
  fade,
  slide,
  scale,
  material,
}
