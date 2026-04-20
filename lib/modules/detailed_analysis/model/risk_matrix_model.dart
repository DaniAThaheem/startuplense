import 'package:flutter/material.dart';

class RiskMatrixModel {
  final String impact;
  final String probability;
  final String title;
  final IconData icon;
  final Color color;

  RiskMatrixModel({
    String? impact,
    String? probability,
    String? title,
    required this.icon,
    required this.color,
  })  : impact = impact ?? "LOW IMPACT",
        probability = probability ?? "LOW PROBABILITY",
        title = title ?? "Unknown Risk";
}
