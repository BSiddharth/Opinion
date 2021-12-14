import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AskUserInfoPageTextFormField extends StatelessWidget {
  AskUserInfoPageTextFormField({
    required this.hintText,
    required this.validator,
    required this.controller,
  });
  final String hintText;
  final TextEditingController controller;
  final validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      maxLength: 20,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        // labelText: labelText,
        counterStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          // color: Colors.grey[400],
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(50.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(50.0),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(50.0),
          ),
        ),
      ),
      // The validator receives the text that the user has entered.
      validator: (value) {
        return validator(value);
      },
    );
  }
}
