import 'package:flutter/material.dart';

class BusinessTypeSelector extends StatelessWidget {
  final String selected;
  final Function(String) onChange;

  const BusinessTypeSelector({
    super.key,
    required this.selected,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final types = ["Product", "Service", "Digital"];

    return Row(
      children: types.map((type) {
        final isActive = selected == type;

        return Expanded(
          child: GestureDetector(
            onTap: () => onChange(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color:
                isActive ? const Color(0xFF22D3EE) : Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  type,
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.white70,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
