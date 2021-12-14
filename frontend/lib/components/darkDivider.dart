import 'package:flutter/material.dart';

class DarkDivider extends StatelessWidget {
  const DarkDivider({
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        height: height,
        color: Colors.black87,
      ),
    );
  }
}
