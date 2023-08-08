import 'package:flutter/material.dart';

class CustomScrollBehavior extends ScrollBehavior {
  const CustomScrollBehavior({required this.androidSdkVersion}) : super();
  final int androidSdkVersion;
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (androidSdkVersion > 30) {
      return StretchingOverscrollIndicator(
        axisDirection: details.direction,
        child: child,
      );
    } else {
      return GlowingOverscrollIndicator(
        axisDirection: details.direction,
        color: Theme.of(context).colorScheme.secondary,
        child: child,
      );
    }
  }
}
