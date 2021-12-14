import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:opinion_frontend/components/darkDivider.dart';
import 'package:opinion_frontend/services/glowRemover.dart';

class AddPageTextField extends StatelessWidget {
  AddPageTextField({
    required this.hintText,
    required this.maxLength,
    required this.minLines,
    required this.textController,
  });
  final int minLines;
  final int maxLength;
  final String hintText;
  final TextEditingController? textController;
  // final String initialText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: GlowRemover(
            child: TextField(
              controller: textController,
              minLines: minLines,
              maxLines: 15,
              maxLength: maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
              cursorColor: Colors.white60,
              cursorWidth: 1.0,
              decoration: InputDecoration(
                fillColor: Colors.grey[900],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                // enabledBorder: InputBorder.none,
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                // disabledBorder: InputBorder.none,
                hintText: hintText,
                hintMaxLines: 10,
                counterStyle: TextStyle(
                  color: Colors.white60,
                ),
                hintStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white60,
                  // color: Colors.grey[400],
                ),
              ),
            ),
          ),
        ),
        DarkDivider(height: 5),
        // Container(
        //   height: 5,
        //   color: Color(0xffF2F2F2),
        // ),
      ],
    );
  }
}
