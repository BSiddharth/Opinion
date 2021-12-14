import 'package:flutter/material.dart';

class VoteShareIndicator extends StatelessWidget {
  const VoteShareIndicator({
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
  });

  final int option1;
  final int option2;
  final int option3;
  final int option4;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 10,
              color: Colors.greenAccent,
            ),
            flex: option1,
          ),
          Expanded(
            child: Container(
              height: 10,
              color: Colors.white,
            ),
            flex: option2,
          ),
          Expanded(
            child: Container(
              height: 10,
              color: Colors.redAccent,
            ),
            flex: option3,
          ),
          Expanded(
            child: Container(
              height: 10,
              color: Color(0xFF707070),
            ),
            flex: option4,
          ),
        ],
      ),
    );
  }
}
