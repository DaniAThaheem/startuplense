import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomActionBar extends StatelessWidget {
  final RxDouble scale;
  final VoidCallback onTap;

  const BottomActionBar({
    super.key,
    required this.scale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "AI will evaluate market, risk, and strategy",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),

              Obx(() => GestureDetector(
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
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4F46E5),
                          Color(0xFF06B6D4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        "Analyze Idea",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
