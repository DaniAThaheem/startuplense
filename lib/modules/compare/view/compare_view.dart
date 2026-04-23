import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
        child: Stack(
          children: [
            _content(),
            Obx(() => controller.isComparing.value
                ? _bottomBar()
                : const SizedBox()),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false, // ❌ removes back button

      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 🔥 important
          mainAxisSize: MainAxisSize.min,
          children: [
            /// GRADIENT TITLE
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
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 4),

            /// SUBTITLE
            Obx(() {
              final ideaA = controller.ideaA.value;
              final ideaB = controller.ideaB.value;

              String subtitle;

              if (ideaA == null || ideaB == null) {
                subtitle = "Select two ideas to compare";
              } else {
                subtitle = "${ideaA.title} vs ${ideaB.title}";
              }

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

      centerTitle: true,

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


  Widget _content() {
    return Obx(() {
      if (controller.isComparing.value) {
        return _comparisonDashboard();
      } else {
        return _selectionLayer();
      }
    });
  }


  Widget _selectionLayer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          _ideaSelector(isA: true),

          const SizedBox(height: 18),

          /// 🔥 VS DIVIDER
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
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.2),
                ],
              ),
            ),
          ),
        ),

        /// VS TEXT (GLASS STYLE)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
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
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.transparent,
                ],
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
        onTap: () async {
          final selectedIdea =
          await Get.toNamed('/idea-history', arguments: {
            "isSelecting": true
          });

          if (selectedIdea != null && selectedIdea is IdeaModel) {
            if (isA) {
              controller.selectIdeaA(selectedIdea);
            } else {
              controller.selectIdeaB(selectedIdea);
            }
          }
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.all(18),

          /// 🔥 GLASS + GRADIENT LAYER
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
              ),
            ]
                : [],
          ),

          child: Stack(
            children: [
              /// 🔥 WATERMARK (IMPROVED)
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
                  /// 🔷 TOP ROW (LABEL + CHANGE)
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
                          onTap: () async {
                            final selectedIdea =
                            await Get.toNamed('/idea-history', arguments: {
                              "isSelecting": true
                            });

                            if (selectedIdea != null &&
                                selectedIdea is IdeaModel) {
                              if (isA) {
                                controller.selectIdeaA(selectedIdea);
                              } else {
                                controller.selectIdeaB(selectedIdea);
                              }
                            }
                          },
                          child: const Text(
                            "Change",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// 🔷 TITLE
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

                  /// 🔷 SCORE SECTION
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
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// 🔷 FOOTER ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        idea != null
                            ? "--"
                            : "No selection",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),

                      /// 🔥 STATUS CHIP
                      if (idea != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                            const Color(0xFF22D3EE).withOpacity(0.15),
                          ),
                          child: const Text(
                            "AI Ready",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF22D3EE),
                            ),
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



  Widget _viabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔥 HEADER ROW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Viability Score",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF22D3EE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "AI LAYER 01",
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF22D3EE),
                ),
              ),
            )
          ],
        ),

        const SizedBox(height: 18),

        _advancedScoreCard(controller.scoreA.value, true),

        const SizedBox(height: 14),

        /// 🔥 INSIGHT PILL
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
              color: Colors.white.withOpacity(0.04),
            ),
            child: Text(
              "Idea A shows ${(controller.scoreA.value - controller.scoreB.value).abs().toInt()}% higher market viability",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        _advancedScoreCard(controller.scoreB.value, false),
      ],
    );
  }



  Widget _riskSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Risk Analysis",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
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
                    letterSpacing: 1,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          _premiumRiskCard(
            title: controller.ideaA.value?.title ?? "Idea A",
            risk: controller.riskA.value,
            factors: ["Niche Market", "High Frequency"],
          ),

          const SizedBox(height: 14),

          _premiumRiskCard(
            title: controller.ideaB.value?.title ?? "Idea B",
            risk: controller.riskB.value,
            factors: ["High Competition", "Financial Uncertainty"],
          ),

          const SizedBox(height: 16),

          /// 🔥 AI INSIGHT BLOCK
          _riskInsight(),
        ],
      );
    });
  }



  Widget _marketSection() {
    final demand = 92.0;
    final competition = 74.0;
    final opportunity = 85.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔥 TITLE
        const Text(
          "Market Intelligence",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 16),

        /// 🔥 MAIN CARD
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
            border: Border.all(color: Colors.white.withOpacity(0.08)),
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

              /// 🔥 AI INSIGHT PANEL
              _aiInsightCard(demand, competition, opportunity),
            ],
          ),
        ),
      ],
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
            /// 🔹 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.4,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                /// VALUE
                Text(
                  "${value.toInt()}%",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isNegative
                        ? Colors.orangeAccent
                        : Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔹 BAR BACKGROUND
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.06),
              ),
              child: Stack(
                children: [
                  /// 🔥 FILLED GRADIENT BAR
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
        _generatePremiumInsight(demand, competition, opportunity),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          height: 1.5,
        ),
      ),
    );
  }

  String _generatePremiumInsight(
      double demand,
      double competition,
      double opportunity,
      ) {
    if (demand > 85 && opportunity > 80 && competition < 70) {
      return "This idea operates in a high-demand, high-growth market with manageable competition, making it a strong candidate for execution.";
    }

    if (competition > 80 && demand > 80) {
      return "Although demand is strong, the market is highly competitive. Success will depend heavily on differentiation and execution strategy.";
    }

    if (opportunity > 85) {
      return "The market shows strong future growth potential, suggesting scalability if early positioning is executed correctly.";
    }

    return "The market conditions are moderately balanced. Further validation and positioning strategy are recommended.";
  }


  Widget _aiRecommendation() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(0.015)
          ..rotateY(-0.01),

        child: Container(
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),

            /// 🔥 MAIN SURFACE (DEPTH GRADIENT)
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1F2937),
                const Color(0xFF0B0F19),
              ],
            ),

            /// 🔥 OUTER BORDER (LIGHT EDGE)
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),

            /// 🔥 MULTI-LAYER SHADOW (FLOATING EFFECT)
            boxShadow: [
              /// bottom heavy shadow
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),

              /// cyan glow (AI feel)
              BoxShadow(
                color: const Color(0xFF22D3EE).withOpacity(0.15),
                blurRadius: 40,
                spreadRadius: 1,
              ),

              /// subtle top light reflection
              BoxShadow(
                color: Colors.white.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),

          child: Stack(
            children: [
              /// 🔥 TOP LIGHT REFLECTION (3D EDGE)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              /// 🔥 AI WATERMARK
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
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "AI Recommendation",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

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
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 🔥 AI PARAGRAPH
                  const Text(
                    "Based on multi-layer AI evaluation, Idea A demonstrates stronger overall viability within the current market landscape. "
                        "It aligns better with demand trends, carries lower execution risk, and shows higher scalability potential. "
                        "In contrast, Idea B faces higher competition pressure and financial uncertainty, which may affect early traction. "
                        "However, with strategic differentiation and positioning, Idea B could still capture a niche segment. "
                        "At this stage, Idea A offers a more stable and execution-ready opportunity.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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

            /// 🔥 GLASS CONTAINER
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white.withOpacity(0.06),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
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
                /// 🔷 PRIMARY BUTTON (GRADIENT)
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      // 👉 Navigate to full report
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF06B6D4).withOpacity(0.4),
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// 🔷 SECONDARY ACTION (SUBTLE)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // 👉 Improve weaker idea
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                        color: Colors.white.withOpacity(0.04),
                      ),
                      child: const Center(
                        child: Text(
                          "Improve",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
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




  Widget _advancedScoreCard(double score, bool isA) {
    final color = _getScoreColor(score);
    final label = _getScoreLabel(score);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
      ),

      child: Row(
        children: [
          /// 🔥 LEFT COLOR STRIP
          Container(
            width: 4,
            height: 120,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔥 HEADER
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 SCORE + ICON ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// SCORE TEXT
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${score.toInt()}",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: "/100",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 🔥 CIRCULAR INDICATOR
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
                                Icon(
                                  Icons.trending_up,
                                  size: 18,
                                  color: color,
                                )
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 🔥 PROGRESS BAR
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
                          valueColor:
                          AlwaysStoppedAnimation<Color>(color),
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


  Widget _premiumRiskCard({
    required String title,
    required String risk,
    required List<String> factors,
  }) {
    Color color;
    String label;

    switch (risk) {
      case "Low":
        color = Colors.greenAccent;
        label = "Low Risk";
        break;
      case "Medium":
        color = Colors.orangeAccent;
        label = "Moderate Risk";
        break;
      default:
        color = Colors.redAccent;
        label = "High Risk";
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        /// 🔥 GLASS GRADIENT
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        /// 🔥 GLOW BORDER
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 1,
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔷 TOP ROW
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              /// 🔥 RISK BADGE
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// 🔷 FACTOR CHIPS
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: factors.map((f) => _riskChip(f)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _riskChip(String text) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
        ),
      ),
    );
  }


  Widget _riskInsight() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.redAccent.withOpacity(0.08),
        border: Border.all(
          color: Colors.redAccent.withOpacity(0.2),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.redAccent, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Idea B carries higher operational risk due to strong competition and financial uncertainty.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }




  void _showInfo() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF0B0F19),
        title: const Text(
          "How Comparison Works",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "We analyze ideas based on viability, risk, market demand and AI insights.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }


}