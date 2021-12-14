import 'package:flutter/material.dart';

class OptionChoosen extends StatelessWidget {
  OptionChoosen({required this.optionChoosen});
  final String optionChoosen;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            optionChoosen,
            // maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
