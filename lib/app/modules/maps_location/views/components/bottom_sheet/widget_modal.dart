import 'package:flutter/material.dart';
class WidgetModal extends StatelessWidget {
  final Widget? child;
  const WidgetModal({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Material(
          color: Colors.white70,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(20),
          child: child,
        ),
      ),
    );
  }
}
