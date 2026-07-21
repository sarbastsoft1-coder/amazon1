import 'package:flutter/widgets.dart';

class Responsive {
  final BuildContext context;
  Responsive(this.context);

  // Screen dimensions
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get shortestSide => MediaQuery.of(context).size.shortestSide;

  // Breakpoints (you can adjust later)
  bool get isSmall => shortestSide < 360;
  bool get isMedium => shortestSide >= 360 && shortestSide < 480;
  bool get isLarge => shortestSide >= 480;

  // Adaptive size helpers (percentage of width/height)
  double wp(double percent) => width * percent / 100;
  double hp(double percent) => height * percent / 100;

  // Adaptive text scaling (optional)
  double scaledFont(double base) => base * MediaQuery.of(context).textScaler.scale(1.0);
}
