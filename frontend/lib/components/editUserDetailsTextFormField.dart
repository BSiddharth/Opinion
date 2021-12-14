import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opinion_frontend/const.dart';

class EditUserDetailsTextFormField extends StatelessWidget {
  EditUserDetailsTextFormField(
      {required this.labelText,
      required this.validator,
      required this.controller,
      required this.maxLength,
      this.maxLines,
      this.minlines});
  final String labelText;
  final TextEditingController controller;
  final validator;
  final int? maxLines;
  final int? minlines;
  final int maxLength;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        minLines: minlines,
        maxLines: maxLines,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          alignLabelWithHint: true,
          fillColor: kGgreyishBlack,
          filled: true,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(15.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(15.0),
            ),
          ),

          //fillColor: Colors.green
        ),
        validator: (val) {},
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontFamily: "Poppins",
          color: Colors.white,
        ),
      ),
    );
  }
}
