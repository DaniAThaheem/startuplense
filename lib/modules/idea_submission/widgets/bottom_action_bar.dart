import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomActionBar extends StatelessWidget {
  final RxDouble scale;
  final VoidCallback onTap;
  final String label; // 🔥 NEW

  const BottomActionBar({
    super.key,
    required this.scale,
    required this.onTap,
    this.label = "Analyze Idea", // 🔥 DEFAULT (important)
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Obx(() => GestureDetector(
            onTapDown: (_) => scale.value = 0.97,
            onTapUp: (_) {
              scale.value = 1.0;
              onTap();
            },
            onTapCancel: () => scale.value = 1.0,
            child: AnimatedScale(
              scale: scale.value,
              duration: const Duration(milliseconds: 100),
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4F46E5),
                      Color(0xFF06B6D4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withOpacity(0.4),
                      blurRadius: 15,
                    )
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome,
                          color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        label, // 🔥 DYNAMIC TEXT
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
