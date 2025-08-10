import 'package:flutter/material.dart';

class GradientOverlay extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<Color> colors;
  final BorderRadius? borderRadius;
  final double height;

  const GradientOverlay({
    super.key,
    required this.begin,
    required this.end,
    required this.colors,
    this.borderRadius,
    this.height = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    double? top;
    double? bottom;
    
    if (begin == Alignment.topCenter) {
      top = 0;
      bottom = null;
    } else if (end == Alignment.bottomCenter) {
      top = null;
      bottom = 0;
    } else {
      top = 0;
      bottom = null;
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: 0,
      right: 0,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: begin,
            end: end,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
