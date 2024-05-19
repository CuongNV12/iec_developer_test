import 'package:flutter/material.dart';

class LinearProgressBar extends StatelessWidget {
  final double percent;

  const LinearProgressBar({
    required this.percent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          width: constraint.maxWidth,
          height: 8,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: percent * constraint.maxWidth,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      },
    );
  }
}
