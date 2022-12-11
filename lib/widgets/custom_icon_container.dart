import 'package:flutter/material.dart';

class CustomIconContainer extends StatelessWidget {
  const CustomIconContainer({
    Key? key,
    required this.icon,
    this.onTap,
    this.containerSize = 50,
  }) : super(key: key);

  final Widget icon;
  final Function()? onTap;
  final double containerSize;

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
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: icon),
      ),
    );
  }
}
