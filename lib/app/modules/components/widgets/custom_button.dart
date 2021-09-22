import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// you have to set isIconShow = true every use an icon
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.text,
    this.backgroundColor,
    this.func,
    this.isIconShow = false,
    this.icon,
    this.textColor,
    this.loading = false,
  }) : super(key: key);

  final String? text;
  final Image? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isIconShow;
  final VoidCallback? func;
  final bool? loading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      child: Container(
        width: Get.width,
        height: 25,
        child: Center(
          child: isIconShow
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: icon,
                    ),
                    SizedBox(width: 15),
                    Text(
                      text ?? "",
                      style: TextStyle(fontSize: 18, color: textColor),
                    ),
                  ],
                )
              : loading == true
                  ? Center(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: SizedBox(
                        height: 16.0,
                        width: 16.0,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Text(
                      text ?? "",
                      style: TextStyle(fontSize: 18, color: textColor),
                    ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
