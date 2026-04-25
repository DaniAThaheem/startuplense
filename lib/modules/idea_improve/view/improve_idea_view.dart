import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/improve_idea_controller.dart';
import '../../idea_submission/widgets/section_title.dart';
import '../../idea_submission/widgets/glass_card.dart';
import '../../idea_submission/widgets/idea_input.dart';
import '../../idea_submission/widgets/idea_textarea.dart';
import '../../idea_submission/widgets/suggestion_block.dart';

class IdeaImproveView extends GetView<IdeaImproveController> {
  const IdeaImproveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Refine Your Idea",
          style: TextStyle(
            color: Color(0xFF22D3EE),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {

          // ── INITIAL LOAD LOADER ──────────────────────────
          if (controller.isLoading.value) {
            return _aiLoader(
              icon:  Icons.auto_fix_high_rounded,
              title: 'AI Improvement Engine',
            );
          }

          // ── SAVE / RE-ANALYSIS LOADER ────────────────────
          if (controller.isSaving.value) {
            return _aiLoader(
              icon:  Icons.psychology_alt_rounded,
              title: 'Re-Analyzing Your Idea',
            );
          }

          // ── MAIN CONTENT ─────────────────────────────────
          return Stack(
            children: [
              _buildContent(),
              _bottomBar(),
            ],
          );
        }),
      ),
    );
  }

  // ===================== AI LOADER =====================

  Widget _aiLoader({required IconData icon, required String title}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // ── PULSING ICON ──────────────────────────────
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.85, end: 1.1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOut,
              builder: (_, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 44),
              ),
            ),

            const SizedBox(height: 32),

            // ── TITLE ─────────────────────────────────────
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ).createShader(bounds),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── ANIMATED MESSAGE ──────────────────────────
            Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: Text(
                controller.loadingMessage.value,
                key: ValueKey(controller.loadingMessage.value),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            )),

            const SizedBox(height: 32),
            const _PulseDots(),
          ],
        ),
      ),
    );
  }

  // ===================== MAIN CONTENT =====================

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _scoreCard(),
          const SizedBox(height: 20),

          // ── TITLE ───────────────────────────────────────
          const SectionTitle("TITLE OPTIMIZATION"),
          GlassCard(
            child: Column(
              children: [
                IdeaInput(
                  controller: controller.titleController,
                  label: "Idea Title",
                  hint: "Refine your idea title",
                ),
                const SizedBox(height: 12),
                Obx(() => SuggestionBlock(
                  title:      "AI Suggestion",
                  suggestion: controller.titleSuggestion.value.suggestion,
                  reason:     controller.titleSuggestion.value.reason,
                  onApply:    controller.applyTitleSuggestion,
                )),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── PROBLEM ─────────────────────────────────────
          const SectionTitle("PROBLEM CLARITY"),
          GlassCard(
            child: Column(
              children: [
                IdeaTextarea(
                  controller: controller.problemController,
                  hint: "Improve problem clarity",
                ),
                const SizedBox(height: 12),
                Obx(() => SuggestionBlock(
                  title:      "AI Suggestion",
                  suggestion: controller.problemSuggestion.value.suggestion,
                  reason:     controller.problemSuggestion.value.reason,
                  onApply:    controller.applyProblemSuggestion,
                )),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── MARKET ──────────────────────────────────────
          const SectionTitle("MARKET IMPROVEMENT"),
          GlassCard(
            child: Column(
              children: [
                IdeaInput(
                  controller: controller.marketController,
                  label: "Target Market",
                  hint: "Refine your audience",
                ),
                const SizedBox(height: 12),
                Obx(() => SuggestionBlock(
                  title:      "AI Suggestion",
                  suggestion: controller.marketSuggestion.value.suggestion,
                  reason:     controller.marketSuggestion.value.reason,
                  onApply:    controller.applyMarketSuggestion,
                )),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── STRATEGY ────────────────────────────────────
          const SectionTitle("STRATEGY IMPROVEMENT"),
          GlassCard(
            child: Column(
              children: [
                IdeaTextarea(
                  controller: controller.strategyController,
                  hint: "Improve your business strategy",
                ),
                const SizedBox(height: 12),
                Obx(() => SuggestionBlock(
                  title:      "AI Suggestion",
                  suggestion: controller.strategySuggestion.value.suggestion,
                  reason:     controller.strategySuggestion.value.reason,
                  onApply:    controller.applyStrategySuggestion,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== SCORE CARD =====================

  Widget _scoreCard() {
    return Center(
      child: GlassCard(
        child: Column(
          children: [
            const Text(
              "Current AI Evaluation Score",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
              "${controller.score.value}/100",
              style: const TextStyle(
                color: Color(0xFF06B6D4),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            )),
            const SizedBox(height: 8),
            const Text(
              "Apply AI suggestions to increase your score",
              style: TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ===================== BOTTOM BAR =====================

  Widget _bottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: GestureDetector(
            onTap: controller.saveImprovedIdea,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    "Save & Re-Analyze",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===================== PULSE DOTS =====================

class _PulseDots extends StatefulWidget {
  const _PulseDots();

  @override
  State<_PulseDots> createState() => _PulseDotsState();
}

class _PulseDotsState extends State<_PulseDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = (_ctrl.value - delay).clamp(0.0, 1.0);
            final scale = 0.6 + 0.6 * (t < 0.5 ? t * 2 : (1 - t) * 2);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 10 * scale,
              height: 10 * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withOpacity(0.4 * scale),
                    blurRadius: 8,
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}