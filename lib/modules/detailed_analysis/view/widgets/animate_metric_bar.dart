
import 'package:flutter/material.dart';


class AnimatedMetricBar extends StatefulWidget {
  final double value;
  final Color color;
  final bool animate;

  const AnimatedMetricBar({
    super.key,
    required this.value,
    required this.color,
    required this.animate,
  });

  @override
  State<AnimatedMetricBar> createState() => _AnimatedMetricBarState();
}

class _AnimatedMetricBarState extends State<AnimatedMetricBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedMetricBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animate && !oldWidget.animate) {
      controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return FractionallySizedBox(
          widthFactor: widget.animate ? animation.value : widget.value,
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color.withOpacity(0.6), widget.color],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}