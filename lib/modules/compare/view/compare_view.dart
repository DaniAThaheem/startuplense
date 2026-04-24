import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:startup_lense/modules/compare/controller/compare_controller.dart';
import 'package:startup_lense/modules/idea_history/controller/Idea_history_controller.dart';

class CompareView extends GetView<CompareController> {
  const CompareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: _appBar(),
      body: SafeArea(
        child: Obx(() {
          // ── AI PERCEPTION LOADER ──────────────────────────
          if (controller.isLoading.value) {
            return _aiLoader();
          }

          return Stack(
            children: [
              _content(),
              Obx(() => controller.isComparing.value
                  ? _bottomBar()
                  : const SizedBox()),
            ],
          );
        }),
      ),
    );
  }

  // ===================== AI LOADER =====================

  Widget _aiLoader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // ── ANIMATED BRAIN ICON ──────────────────────────
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOut,
              builder: (_, scale, child) => Transform.scale(
                scale: scale, child: child,
              ),
              onEnd: () {},
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
                child: const Icon(
                  Icons.psychology_alt_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── TITLE ────────────────────────────────────────
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ).createShader(bounds),
              child: const Text(
                'AI Comparison Engine',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── ANIMATED STEP MESSAGE ────────────────────────
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

            // ── PROGRESS DOTS ────────────────────────────────
            const _PulseDots(),

            const SizedBox(height: 40),

            // ── IDEA PILLS ───────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ideaPill(
                  controller.ideaA.value?.title ?? '',
                  const Color(0xFF4F46E5),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _ideaPill(
                  controller.ideaB.value?.title ?? '',
                  const Color(0xFF06B6D4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ideaPill(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ===================== APP BAR =====================

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ).createShader(bounds),
              child: const Text(
                "Compare Ideas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Obx(() {
              final a = controller.ideaA.value;
              final b = controller.ideaB.value;
              final subtitle = (a == null || b == null)
                  ? "Select two ideas to compare"
                  : "${a.title} vs ${b.title}";
              return Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          onPressed: _showInfo,
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white70),
          onPressed: controller.reset,
        ),
      ],
    );
  }

  // ===================== CONTENT =====================

  Widget _content() {
    return Obx(() {
      if (controller.isComparing.value) return _comparisonDashboard();
      return _selectionLayer();
    });
  }

  Widget _selectionLayer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          _ideaSelector(isA: true),
          const SizedBox(height: 18),
          _vsDivider(),
          const SizedBox(height: 18),
          _ideaSelector(isA: false),
        ],
      ),
    );
  }

  Widget _vsDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.white.withOpacity(0.2)],
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: const Text(
            "VS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.2), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ideaSelector({required bool isA}) {
    final ideaRx = isA ? controller.ideaA : controller.ideaB;

    return Obx(() {
      final idea = ideaRx.value;

      return GestureDetector(
        onTap: () => _pickIdea(isA),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: idea != null
                  ? const Color(0xFF22D3EE)
                  : Colors.white.withOpacity(0.08),
              width: 1.2,
            ),
            boxShadow: idea != null
                ? [
              BoxShadow(
                color: const Color(0xFF22D3EE).withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 1,
              )
            ]
                : [],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -8,
                right: -8,
                child: Icon(
                  Icons.auto_awesome,
                  size: 70,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isA ? "CONCEPT A" : "CONCEPT B",
                        style: const TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF22D3EE),
                        ),
                      ),
                      if (idea != null)
                        GestureDetector(
                          onTap: () => _pickIdea(isA),
                          child: const Text(
                            "Change",
                            style: TextStyle(fontSize: 12, color: Colors.cyan),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    idea?.title ?? "Select an idea",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: idea != null
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        idea != null ? "${idea.score}" : "--",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          "score",
                          style: TextStyle(fontSize: 12, color: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        idea?.status ?? "No selection",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      if (idea != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF22D3EE).withOpacity(0.15),
                          ),
                          child: const Text(
                            "AI Ready",
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF22D3EE)),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _pickIdea(bool isA) async {
    final selected = await Get.toNamed(
      '/idea-history',
      arguments: {"isSelecting": true},
    );
    if (selected != null && selected is IdeaModel) {
      if (isA) {
        controller.selectIdeaA(selected);
      } else {
        controller.selectIdeaB(selected);
      }
    }
  }

  // ===================== COMPARISON DASHBOARD =====================

  Widget _comparisonDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
      child: Column(
        children: [
          _viabilitySection(),
          const SizedBox(height: 20),
          _riskSection(),
          const SizedBox(height: 20),
          _marketSection(),
          const SizedBox(height: 20),
          _aiRecommendation(),
        ],
      ),
    );
  }

  // ── Viability ─────────────────────────────────────────────

  Widget _viabilitySection() {
    return Obx(() {
      final r = controller.result.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Viability Score",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF22D3EE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "AI LAYER 01",
                  style: TextStyle(fontSize: 11, color: Color(0xFF22D3EE)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _advancedScoreCard(controller.scoreA.value, true),
          const SizedBox(height: 14),

          // ── AI insight pill ──────────────────────────────
          Center(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border:
                Border.all(color: Colors.white.withOpacity(0.15)),
                color: Colors.white.withOpacity(0.04),
              ),
              child: Text(
                r?.viabilityInsight ??
                    "Idea A shows ${(controller.scoreA.value - controller.scoreB.value).abs().toInt()}% higher market viability",
                textAlign: TextAlign.center,
                style:
                const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ),

          const SizedBox(height: 14),
          _advancedScoreCard(controller.scoreB.value, false),
        ],
      );
    });
  }

  // ── Risk ──────────────────────────────────────────────────

  Widget _riskSection() {
    return Obx(() {
      final r = controller.result.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Risk Analysis",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: const Text(
                  "AI Layer 02",
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.white54,
                      letterSpacing: 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _premiumRiskCard(
            title: controller.ideaA.value?.title ?? "Idea A",
            risk: r?.riskA ?? "Medium",
            factors: r?.riskFactorsA ?? ["Analyzing..."],
          ),
          const SizedBox(height: 14),
          _premiumRiskCard(
            title: controller.ideaB.value?.title ?? "Idea B",
            risk: r?.riskB ?? "Medium",
            factors: r?.riskFactorsB ?? ["Analyzing..."],
          ),
          const SizedBox(height: 16),
          _riskInsight(r?.riskInsight),
        ],
      );
    });
  }

  // ── Market ────────────────────────────────────────────────

  Widget _marketSection() {
    return Obx(() {
      final r = controller.result.value;
      final demand      = r?.marketDemand      ?? 0;
      final competition = r?.marketCompetition ?? 0;
      final opportunity = r?.marketOpportunity ?? 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Market Intelligence",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.07),
                  Colors.white.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border:
              Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                _premiumBar(
                  label: "Market Demand",
                  value: demand,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF22D3EE)],
                  ),
                  delay: 200,
                ),
                const SizedBox(height: 20),
                _premiumBar(
                  label: "Competition Intensity",
                  value: competition,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF97316), Color(0xFFFB7185)],
                  ),
                  delay: 400,
                  isNegative: true,
                ),
                const SizedBox(height: 20),
                _premiumBar(
                  label: "Growth Opportunity",
                  value: opportunity,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF22C55E), Color(0xFF4ADE80)],
                  ),
                  delay: 600,
                ),
                const SizedBox(height: 22),
                _aiInsightCard(
                  demand,
                  competition,
                  opportunity,
                  r?.marketInsight,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  // ── AI Recommendation ─────────────────────────────────────

  Widget _aiRecommendation() {
    return Obx(() {
      final r = controller.result.value;

      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(0.015)
          ..rotateY(-0.01),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1F2937), Color(0xFF0B0F19)],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.7),
                  blurRadius: 30,
                  offset: const Offset(0, 18)),
              BoxShadow(
                  color: const Color(0xFF22D3EE).withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: 1),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -12,
                right: -12,
                child: Icon(
                  Icons.psychology_alt_rounded,
                  size: 100,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "AI Recommendation",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),

                      // ── Winner badge ──────────────────────
                      if (r != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4F46E5),
                                Color(0xFF06B6D4)
                              ],
                            ),
                          ),
                          child: Text(
                            "Idea ${r.winner} Wins",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: const Text(
                            "FINAL VERDICT",
                            style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 1.2,
                                color: Colors.white54),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    r?.recommendation ??
                        "AI analysis complete. Results displayed above.",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                  ),

                  // ── Strength pills ────────────────────────
                  if (r != null) ...[
                    const SizedBox(height: 20),
                    _strengthRow(
                        "Idea A: ${r.strengthA}",
                        const Color(0xFF4F46E5)),
                    const SizedBox(height: 10),
                    _strengthRow(
                        "Idea B: ${r.strengthB}",
                        const Color(0xFF06B6D4)),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _strengthRow(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
            ),
          ),
        ],
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
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white.withOpacity(0.06),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                            const Color(0xFF06B6D4).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.analytics, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "View Report",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: controller.reset,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.15)),
                        color: Colors.white.withOpacity(0.04),
                      ),
                      child: const Center(
                        child: Text(
                          "Reset",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== REUSABLE WIDGETS =====================

  Widget _advancedScoreCard(double score, bool isA) {
    final color = _getScoreColor(score);
    final label = _getScoreLabel(score);
    final title = isA
        ? (controller.ideaA.value?.title ?? "Idea A")
        : (controller.ideaB.value?.title ?? "Idea B");

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 120,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2),
                      ),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "${score.toInt()}",
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          TextSpan(
                            text: "/100",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ]),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: score / 100),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, value, _) {
                          return SizedBox(
                            width: 44,
                            height: 44,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 4,
                                  backgroundColor: Colors.white10,
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(color),
                                ),
                                Icon(Icons.trending_up,
                                    size: 18, color: color),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: score / 100),
                    duration: const Duration(milliseconds: 700),
                    builder: (context, value, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 6,
                          backgroundColor: Colors.white10,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumRiskCard({
    required String title,
    required String risk,
    required List<String> factors,
  }) {
    final color = _getRiskColor(risk);
    final label = _getRiskLabel(risk);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withOpacity(0.4), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 1)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: color.withOpacity(0.15),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: factors.map(_riskChip).toList(),
          ),
        ],
      ),
    );
  }

  Widget _riskChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white70, fontSize: 11)),
    );
  }

  Widget _riskInsight(String? insight) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.redAccent.withOpacity(0.08),
        border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.redAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              insight ??
                  "Risk comparison analyzed. Review the cards above.",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumBar({
    required String label,
    required double value,
    required LinearGradient gradient,
    required int delay,
    bool isNegative = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value / 100),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, val, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.4,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "${value.toInt()}%",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isNegative ? Colors.orangeAccent : Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.06),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: val,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: gradient,
                        boxShadow: [
                          BoxShadow(
                            color: gradient.colors.last.withOpacity(0.4),
                            blurRadius: 12,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _aiInsightCard(
      double demand,
      double competition,
      double opportunity,
      String? aiInsight,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4F46E5).withOpacity(0.15),
            const Color(0xFF06B6D4).withOpacity(0.10),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Text(
        aiInsight ?? _generateFallbackInsight(demand, competition, opportunity),
        style: const TextStyle(
            color: Colors.white70, fontSize: 13, height: 1.5),
      ),
    );
  }

  String _generateFallbackInsight(
      double demand, double competition, double opportunity) {
    if (demand > 85 && opportunity > 80 && competition < 70) {
      return "High-demand, high-growth market with manageable competition.";
    }
    if (competition > 80 && demand > 80) {
      return "Strong demand but highly competitive. Differentiation is key.";
    }
    if (opportunity > 85) {
      return "Strong future growth potential with good scalability.";
    }
    return "Moderately balanced market conditions. Further validation recommended.";
  }

  // ===================== HELPERS =====================

  Color _getScoreColor(double score) {
    if (score >= 75) return Colors.greenAccent;
    if (score >= 50) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  String _getScoreLabel(double score) {
    if (score >= 75) return "STRONG VIABILITY";
    if (score >= 50) return "MODERATE VIABILITY";
    return "WEAK VIABILITY";
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':    return Colors.greenAccent;
      case 'medium': return Colors.orangeAccent;
      default:       return Colors.redAccent;
    }
  }

  String _getRiskLabel(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':    return "Low Risk";
      case 'medium': return "Moderate Risk";
      default:       return "High Risk";
    }
  }

  void _showInfo() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0B0F19),
        title: const Text("How Comparison Works",
            style: TextStyle(color: Colors.white)),
        content: const Text(
          "We analyze ideas based on viability, risk, market demand and AI insights.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text("Close")),
        ],
      ),
    );
  }
}

// ===================== PULSE DOTS WIDGET =====================

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