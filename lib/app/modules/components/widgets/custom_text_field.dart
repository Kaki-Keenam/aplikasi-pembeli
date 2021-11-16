import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/utils/constants/app_colors.dart';

class NewCustomTextField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final bool obsecureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final Color? backgroundColour;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  NewCustomTextField({
    required this.title,
    required this.hint,
    this.readOnly = false,
    this.backgroundColour,
    this.controller,
    this.obsecureText = false,
    this.padding,
    this.margin, this.validator, this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              '$title',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(color: AppColor.primaryExtraSoft, borderRadius: BorderRadius.circular(10)),
              ),
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.013),
                child: TextFormField(
                  controller: controller,
                  readOnly: readOnly,
                  style: TextStyle(fontSize: 14),
                  cursorColor: AppColor.primary,
                  keyboardType: keyboardType,
                  obscureText: obsecureText,
                  validator: validator,
                  decoration: InputDecoration(
                    fillColor: backgroundColour,
                    hintText: '$hint',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    contentPadding: EdgeInsets.only(left: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
