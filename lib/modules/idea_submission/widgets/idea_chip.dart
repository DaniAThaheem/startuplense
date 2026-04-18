import 'package:flutter/material.dart';

class IdeaChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function() onTap;

  const IdeaChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.green,
      backgroundColor: Colors.white10,
    );
  }
}
