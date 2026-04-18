import 'package:flutter/material.dart';

class SuggestionBlock extends StatelessWidget {
  final String title;
  final String suggestion;
  final String reason;
  final VoidCallback onApply;

  const SuggestionBlock({
    super.key,
    required this.title,
    required this.suggestion,
    required this.reason,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.withOpacity(0.08),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 TITLE
          Text(
            title,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 6),

          // 🔹 SUGGESTION
          Text(
            suggestion,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 6),

          // 🔹 REASON (AI EXPLANATION)
          Text(
            reason,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 APPLY BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onApply,
              style: TextButton.styleFrom(
                foregroundColor: Colors.cyanAccent,
              ),
              child: const Text("Apply"),
            ),
          )
        ],
      ),
    );
  }
}
