import 'package:flutter/material.dart';

class LinearProgressBar extends StatelessWidget {
  final double percent;
  final double width;

  const LinearProgressBar({
    required this.percent,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 8,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: percent * width,
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
