import 'package:flutter/material.dart';

class AppIconContainer extends StatelessWidget {
  final Widget icon;
  final double containerSize;
  final VoidCallback? onTap;
  const AppIconContainer(this.icon,
      {this.onTap, this.containerSize = 50, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: containerSize,
        height: containerSize,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
