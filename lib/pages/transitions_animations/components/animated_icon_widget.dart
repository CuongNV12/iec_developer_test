import 'package:flutter/material.dart';
import 'package:iec_developer_test/pages/transitions_animations/components/coordinates.dart';

class AnimatedIconWidget extends StatefulWidget {
  final bool isMoved;
  final GlobalKey iconKey;
  final Coordinate coordinatesDistance;
  final double left;
  final void Function()? onEnd;

  const AnimatedIconWidget({
    required this.isMoved,
    required this.iconKey,
    required this.coordinatesDistance,
    required this.left,
    this.onEnd,
    super.key,
  });

  @override
  State<AnimatedIconWidget> createState() => _AnimatedIconWidgetState();
}

class _AnimatedIconWidgetState extends State<AnimatedIconWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: widget.isMoved ? 500 : 0),
      top: widget.isMoved ? widget.coordinatesDistance.dy + 16 : 16,
      left: widget.isMoved
          ? widget.coordinatesDistance.dx + widget.left
          : widget.left,
      width: widget.isMoved ? 20 : 50,
      height: widget.isMoved ? 20 : 50,
      onEnd: widget.onEnd,
      child: FittedBox(
        key: widget.iconKey,
        child: const Icon(
          Icons.star,
        ),
      ),
    );
  }
}
