import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPostCustomOptions extends StatelessWidget {
  const AddPostCustomOptions({
    required this.hintText,
    required this.controller,
    required this.validator,
  });
  final String hintText;
  final TextEditingController? controller;
  final Function validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: TextFormField(
        validator: validator as String? Function(String?)?,
        minLines: 1,
        maxLines: 3,
        maxLength: 130,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        controller: controller,
        cursorColor: Colors.black,
        cursorWidth: 1.5,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black54, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black54, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          filled: true,
          hintStyle: new TextStyle(color: Colors.grey[800]),
          hintText: hintText,
          fillColor: Colors.white70,
          counterText: "",
        ),
      ),
    );
  }
}
