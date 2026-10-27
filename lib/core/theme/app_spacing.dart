import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class AppSpacing {
  AppSpacing._();

  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const page = EdgeInsets.all(md);

  /// Widest a scrolling content column grows before it is centred.
  static const maxContentWidth = 600.0;

  /// [page] padding that centres content at [maxContentWidth] on wide screens.
  static EdgeInsets pageFor(double width) => EdgeInsets.symmetric(
    horizontal: math.max(md, (width - maxContentWidth) / 2),
    vertical: md,
  );
}
