import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {

  // ── Controllers ──────────────────────────────────────────────
  late AnimationController _raysController;
  late AnimationController _boltController;
  late AnimationController _glowController;
  late AnimationController _textController;
  late AnimationController _taglineController;

  // ── Rays (lightning burst)
  late Animation<double> _raysOpacity;
  late Animation<double> _raysScale;

  // ── Bolt
  late Animation<double> _boltOpacity;
  late Animation<double> _boltScale;

  // ── Glow ring
  late Animation<double> _glowOpacity;
  late Animation<double> _glowRadius;

  // ── App name
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  // ── Tagline
  late Animation<double> _taglineOpacity;

  // ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    // 1. Rays burst — 600ms
    _raysController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _raysOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _raysController, curve: Curves.easeOut));
    _raysScale = Tween<double>(begin: 0.3, end: 2.2).animate(
      CurvedAnimation(parent: _raysController, curve: Curves.easeOut),
    );

    // 2. Bolt — 800ms
    _boltController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _boltOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _boltController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _boltScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _boltController, curve: Curves.easeOutBack),
    );

    // 3. Glow pulse — 1200ms looping
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _glowOpacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeOut),
    );
    _glowRadius = Tween<double>(begin: 60.0, end: 130.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeOut),
    );

    // 4. App name — 700ms
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));

    // 5. Tagline — 600ms
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    _runSequence();
  }

  void _runSequence() async {
    // Guard: don't navigate if widget was disposed mid-animation
    if (!mounted) return;

    // Stage 1 — lightning burst
    await _raysController.forward();
    if (!mounted) return;

    // Stage 2 — bolt appears
    await Future.delayed(const Duration(milliseconds: 100));
    _boltController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    // Stage 3 — glow pulses
    _glowController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _glowController.repeat();
    await Future.delayed(const Duration(milliseconds: 800));
    _glowController.stop();
    if (!mounted) return;

    // Stage 4 — app name slides up
    await _textController.forward();
    if (!mounted) return;

    // Stage 5 — tagline fades in
    await Future.delayed(const Duration(milliseconds: 150));
    await _taglineController.forward();
    if (!mounted) return;

    // Hold so user reads the screen
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // ✅ Splash owns navigation — fires only after full animation
    final authController = Get.find<AuthController>();
    Get.offAllNamed(authController.initialRoute);
  }

  @override
  void dispose() {
    _raysController.dispose();
    _boltController.dispose();
    _glowController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D1A), Color(0xFF111827)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [

            // ── Background radial ambient glow (static, always on) ──
            Center(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF4F46E5).withOpacity(0.18),
                      const Color(0xFF06B6D4).withOpacity(0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // ── Lightning rays burst ──
            Center(
              child: AnimatedBuilder(
                animation: _raysController,
                builder: (context, _) {
                  return Opacity(
                    opacity: _raysOpacity.value,
                    child: Transform.scale(
                      scale: _raysScale.value,
                      child: CustomPaint(
                        size: const Size(200, 200),
                        painter: _LightningRaysPainter(),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Glow ring pulse ──
            Center(
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (context, _) {
                  return Opacity(
                    opacity: _glowOpacity.value,
                    child: Container(
                      width: _glowRadius.value * 2,
                      height: _glowRadius.value * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF06B6D4).withOpacity(0.5),
                            const Color(0xFF4F46E5).withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Main content: Bolt + Name + Tagline ──
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Bolt icon
                  AnimatedBuilder(
                    animation: _boltController,
                    builder: (context, _) {
                      return Opacity(
                        opacity: _boltOpacity.value,
                        child: Transform.scale(
                          scale: _boltScale.value,
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF06B6D4), Color(0xFF4F46E5)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: const Icon(
                              Icons.bolt_rounded,
                              size: 90,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // App name
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _textOpacity,
                        child: SlideTransition(
                          position: _textSlide,
                          child: child,
                        ),
                      );
                    },
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFE5E7EB), Color(0xFF9CA3AF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'StartupLense',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  FadeTransition(
                    opacity: _taglineOpacity,
                    child: const Text(
                      'AI-Powered Idea Validation',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF06B6D4),
                        letterSpacing: 2.4,
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

// ── Lightning rays CustomPainter ─────────────────────────────────
class _LightningRaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const rayCount = 12;
    const innerRadius = 28.0;
    const outerRadius = 90.0;

    for (int i = 0; i < rayCount; i++) {
      final angle = (2 * pi * i) / rayCount;
      // Alternate long and short rays for a burst feel
      final outer = i.isEven ? outerRadius : outerRadius * 0.6;

      final start = Offset(
        center.dx + innerRadius * cos(angle),
        center.dy + innerRadius * sin(angle),
      );
      final end = Offset(
        center.dx + outer * cos(angle),
        center.dy + outer * sin(angle),
      );

      // Gradient color per ray: alternate cyan and indigo
      paint.color = i.isEven
          ? const Color(0xFF06B6D4).withOpacity(0.9)
          : const Color(0xFF4F46E5).withOpacity(0.8);

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(_LightningRaysPainter oldDelegate) => false;
}