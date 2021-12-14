import 'package:flutter/material.dart';

class GlowRemover extends StatelessWidget {
  GlowRemover({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return true;
      },
      child: child,
    );
  }
}
