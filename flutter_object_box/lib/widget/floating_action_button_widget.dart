import 'package:flutter/material.dart';

class FloatingActionWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? iconName;
  final double? iconSize;
  const FloatingActionWidget({super.key, this.iconName, this.iconSize, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromARGB(255, 85, 227, 213),
      ),
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            iconName,
            size: iconSize,
          )),
    );
  }
}
