import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.obscureText,
    this.suffixIcon,
    this.backgroundColor, this.readOnly, this.validator,
  }) : super(key: key);

  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final FormFieldValidator<String>? validator;
  final bool? readOnly;
  final Color? backgroundColor;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      focusNode: FocusNode(skipTraversal: true),
      validator: validator,
      decoration: InputDecoration(
        isDense: true,
        fillColor: backgroundColor ?? Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        focusColor: Colors.amber[600],
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon ?? null,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.black38, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.amber[600]!, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.amber[600]!, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.amber[600]!, width: 2),
        ),
      ),
    );
  }
}
