import 'package:flutter/material.dart';
import 'package:iec_developer_test/pages/transitions_animations/components/linear_progress_bar.dart';
import 'package:lottie/lottie.dart';

class ProgressContainerWidget extends StatefulWidget {
  final GlobalKey destinationKey;
  final Stream<Color>? stream;
  final double percent;
  final String value;

  const ProgressContainerWidget({
    required this.destinationKey,
    required this.stream,
    required this.percent,
    required this.value,
    super.key,
  });

  @override
  State<ProgressContainerWidget> createState() =>
      _ProgressContainerWidgetState();
}

class _ProgressContainerWidgetState extends State<ProgressContainerWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<Color>(
        stream: widget.stream,
        initialData: Colors.grey[300],
        builder: (context, snapshot) {
          final color = snapshot.data!;
          final isHighLight = color == Colors.grey;
          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: size.width,
                margin: const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
                padding: EdgeInsets.all(isHighLight ? 15 : 16),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                // alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('NEXT MILESTONE'),
                        ),
                        Lottie.asset(
                          key: widget.destinationKey,
                          fit: BoxFit.cover,
                          'assets/lottie/ic_heart.json',
                          width: 20,
                          height: 20,
                          controller: AnimationController(
                            vsync: this,
                            duration: const Duration(milliseconds: 0),
                          )..forward(),
                        ),
                        const SizedBox(width: 4),
                        Text(widget.value),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressBar(
                      percent: widget.percent,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
