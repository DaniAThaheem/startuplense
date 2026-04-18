import 'package:flutter/material.dart';
import 'dart:math';

class BudgetSlider extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const BudgetSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  // 🔹 Format PKR properly (1,00,000 style)
  String formatPKR(double amount) {
    int val = amount.toInt();
    String str = val.toString();

    if (str.length <= 3) return str;

    String result = '';
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;

      if (count == 3 && i != 0) {
        result = ',' + result;
        count = 0;
      }
    }

    return result;
  }

  // 🔹 Snap logic (10K steps)
  double snap(double val) {
    const step = 10000;
    return (val / step).round() * step.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    const min = 10000.0;
    const max = 1000000.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Estimated Budget",
              style: TextStyle(
                color: Color(0xFF22D3EE),
                fontSize: 14,
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value),
              duration: const Duration(milliseconds: 300),
              builder: (context, val, _) {
                return Text(
                  "PKR ${formatPKR(val)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 10),

        // 🔹 SLIDER WITH GLOW
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),

            activeTrackColor: const Color(0xFF06B6D4),
            inactiveTrackColor: Colors.white24,

            thumbColor: const Color(0xFF06B6D4),
            overlayColor: const Color(0xFF06B6D4).withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) ~/ 10000), // 🔹 tick snapping
            onChanged: (val) => onChanged(snap(val)),
          ),
        ),

        const SizedBox(height: 6),

        // 🔹 TICK MARK VISUAL SCALE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return Container(
              width: 2,
              height: 8,
              color: Colors.white24,
            );
          }),
        ),

        const SizedBox(height: 6),

        // 🔹 MIN / MAX LABELS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PKR ${formatPKR(min)}",
              style: const TextStyle(color: Colors.white38),
            ),
            Text(
              "PKR ${formatPKR(max)}",
              style: const TextStyle(color: Colors.white38),
            ),
          ],
        ),
      ],
    );
  }
}
