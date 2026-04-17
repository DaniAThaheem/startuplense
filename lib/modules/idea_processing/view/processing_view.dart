import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/processing_controller.dart';

class ProcessingView extends GetView<ProcessingController> {
  const ProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
          Icons.bolt,
          color: Color(0xFF06B6D4),
          size: 24,
        ),
        ),

        title: const Text(
          "ANALYZING",
          style: TextStyle(
            color: Color(0xFF22D3EE),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),

        actions: [
          TextButton(
            onPressed: controller.cancelProcessing,
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    _progressCircle(),
                    const SizedBox(height: 30),
                    _progressBar(),
                    const SizedBox(height: 40),
                    _steps(),
                    const SizedBox(height: 30),
                    _statusText(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔷 CIRCULAR PROGRESS
  Widget _progressCircle() {
    return Obx(() {
      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: controller.progress.value),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, _) {
          return CustomPaint(
            painter: CirclePainter(value),
            child: SizedBox(
              width: 220,
              height: 220,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.psychology,
                        color: Color(0xFF06B6D4), size: 40),
                    const SizedBox(height: 10),
                    Text(
                      "${value.toInt()}%",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text("COMPLETE",
                        style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // 🔷 PROGRESS BAR
  Widget _progressBar() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Overall Progress",
              style: TextStyle(color: Colors.white54)),
        ),
        const SizedBox(height: 10),
        Obx(() {
          return LinearProgressIndicator(
            value: controller.progress.value / 100,
            minHeight: 4,
            backgroundColor: Colors.white12,
            valueColor:
            const AlwaysStoppedAnimation(Color(0xFF06B6D4)),
          );
        }),
      ],
    );
  }

  // 🔷 STEPS PIPELINE
  Widget _steps() {
    return Obx(() {
      return Column(
        children: controller.steps.map((step) {
          return _stepItem(step);
        }).toList(),
      );
    });
  }

  Widget _stepItem(Map step) {
    Color color;
    String status = step["status"];

    if (status == "done") {
      color = const Color(0xFF10B981);
    } else if (status == "processing") {
      color = const Color(0xFF06B6D4);
    } else {
      color = Colors.white24;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: status == "processing"
              ? const Color(0xFF06B6D4)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            status == "done"
                ? Icons.check_circle
                : Icons.circle,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step["title"],
              style: TextStyle(
                color: status == "waiting"
                    ? Colors.white38
                    : Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            status.toUpperCase(),
            style: TextStyle(color: color, fontSize: 12),
          )
        ],
      ),
    );
  }

  // 🔷 STATUS TEXT
  Widget _statusText() {
    return Obx(() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Text(
          controller.statusText.value,
          key: ValueKey(controller.statusText.value),
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white54, fontSize: 14),
        ),
      );
    });
  }
}




class CirclePainter extends CustomPainter {
  final double progress;
  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double stroke = 10;

    Rect rect = Offset.zero & size;

    Paint bg = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    Paint fg = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
        rect.deflate(stroke),
        -pi / 2,
        2 * pi,
        false,
        bg);

    canvas.drawArc(
        rect.deflate(stroke),
        -pi / 2,
        2 * pi * (progress / 100),
        false,
        fg);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
