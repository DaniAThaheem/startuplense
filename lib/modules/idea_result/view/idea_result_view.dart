import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:startup_lense/modules/idea_result/controller/idea_result-controller.dart';
import 'package:startup_lense/modules/idea_result/widgets/animated_score_ring.dart';
import 'package:startup_lense/modules/idea_result/widgets/parallax_card.dart';
import 'package:startup_lense/modules/idea_result/widgets/skeleton_box.dart';
import 'package:startup_lense/routes/app_routes.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResultController());

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: _appBar(),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _animatedCard(index: 1, child: _scoreCard(controller)),
                const SizedBox(height: 20),

                _animatedCard(index: 2, child: Obx(() {
                  if (controller.isLoading.value) {
                    return _strategySkeleton();
                  }
                  return _marketCard();
                }, )),
                const SizedBox(height: 20),

                _animatedCard(index: 3, child: Obx(() {
                  if (controller.isLoading.value) {
                    return _strategySkeleton();
                  }
                  return _riskCard();
                }),),
                const SizedBox(height: 20),

                _animatedCard(index: 4, child: Obx(() {
                  if (controller.isLoading.value) {
                    return _strategySkeleton();
                  }
                  return _structureCard();
                }),
                    ),
                const SizedBox(height: 20),

                _animatedCard(index: 5, child: Obx(() {
                  if (controller.isLoading.value) {
                    return _strategySkeleton();
                  }
                  return _strategySection();
                }),
                ),
                const SizedBox(height: 20),

                _animatedCard(index: 6, child: Obx(() {
                  if (controller.isLoading.value) {
                    return _strategySkeleton();
                  }
                  return Obx(() => _finalVerdict(controller));
                }),
                    ),
                const SizedBox(height: 30),

                Obx(() {
                  if (controller.isLoading.value) {
                    return _strategySkeleton();
                  }
                  return _actionButtons();
                }),






              ],

            ),
          );

        }),
      ),
    );

  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0B0F19),
      elevation: 0,

      // 🔥 FIX BACK ICON COLOR
      iconTheme: const IconThemeData(color: Colors.white),

      centerTitle: true,

      // 🔥 GRADIENT TITLE
      title: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
        ).createShader(bounds),
        child: const Text(
          "Evaluation Report",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // required for shader
          ),
        ),
      ),

      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.white70),
          onPressed: controller.exportPremiumReport
        ),
      ],
    );
  }

  Widget _scoreCard(ResultController c) {
    return ParallaxCard(child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Obx(() => AnimatedScoreRing(
            score: controller.score.value,
          )),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _chip("Confidence", c.confidence.value),
              const SizedBox(width: 10),
              _chip("Agreement", c.agreement.value),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            c.verdictLine.value,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          )
        ],
      ),
    ));

  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF06B6D4)),
        color: const Color(0x2206B6D4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _marketCard() {
    return
      ParallaxCard(
        child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔷 TITLE
            const Text(
              "Market Intelligence",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Obx(() {
              if (controller.marketSignals.isEmpty) {
                return const SizedBox(); // avoid empty crash
              }

              return Wrap(
                spacing: 8,
                children: controller.marketSignals
                    .map((e) => _signalChip(e))
                    .toList(),
              );
            }),

            const SizedBox(height: 18),

            // 🔷 3 COLUMN GRID
            Obx(() => Row(
              children: [
                _metricColumn("Demand", controller.demand.value),
                const SizedBox(width: 12),

                _metricColumn("Competition", controller.competition.value),
                const SizedBox(width: 12),

                _metricColumn("Saturation", controller.saturation.value),
              ],
            )),

            const SizedBox(height: 16),

            // 🔷 INSIGHT
            Obx(() => Text(
              controller.marketInsight.value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            )),

            const SizedBox(height: 10),

            // 🔷 TAGS
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.marketTags
                  .map((tag) => _tag(tag))
                  .toList(),
            )),


          ],
        ),
            ),
      );
  }

  Color _riskColor(String level) {
    switch (level.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _riskRow(String metric, String level) {
    final color = _riskColor(level);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          // 🔹 LEFT → METRIC NAME
          Expanded(
            child: Text(
              metric,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),

          // 🔹 RIGHT → LEVEL INDICATOR
          Row(
            children: [
              // colored dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                level,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
        color: Colors.orange.withOpacity(0.12),
        border: Border.all(color: Colors.orange.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


  Widget _riskCard() {
    return
      ParallaxCard(
        child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔷 TITLE
            const Text(
              "Risk Matrix",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // 🔷 TABLE
            Obx(() => Column(
              children: [
                _riskRow("Market", controller.marketRisk.value),
                Divider(color: Colors.white10),

                _riskRow("Financial", controller.financialRisk.value),
                Divider(color: Colors.white10),

                _riskRow("Technical", controller.technicalRisk.value),
              ],
            )),

            const SizedBox(height: 16),

            // 🔷 INSIGHT
            Obx(() => Text(
              controller.riskInsight.value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            )),

            const SizedBox(height: 10),

            // 🔷 CHIPS
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.riskTags
                  .map((e) => _riskChip(e))
                  .toList(),
            )),
          ],
        ),
            ),
      );
  }

  double _getProgress(String level) {
    switch (level.toLowerCase()) {
      case "high":
        return 0.85;
      case "medium":
        return 0.55;
      case "low":
        return 0.30;
      default:
        return 0.0;
    }
  }

  Color _getColor(String level) {
    switch (level.toLowerCase()) {
      case "high":
        return Colors.green;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _metricColumn(String title, String level) {
    final progress = _getProgress(level);
    final color = _getColor(level);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔹 Metric Name
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 8),

          // 🔹 Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white12,
            ),
          ),

          const SizedBox(height: 8),

          // 🔹 Level Text
          Text(
            level,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _signalChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        // 🔥 Transparent green fill
        color: Colors.green.withOpacity(0.12),

        // 🔥 Soft green border
        border: Border.all(
          color: Colors.green.withOpacity(0.4),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.green,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _structureCard() {
    return
      ParallaxCard(
        child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔷 TITLE
            const Text(
              "Structure Validation",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // 🔷 ROWS
            Obx(() => Column(
              children: [

                _structureRow("Problem", controller.problemStrength.value),
                Divider(color: Colors.white10),

                _structureRow("Value Proposition", controller.valuePropStrength.value),
                Divider(color: Colors.white10),

                _structureRow("Audience", controller.audienceClarity.value),
              ],
            )),

            const SizedBox(height: 26),

            // 🔷 TAGS (CONSISTENT WITH OTHER CARDS)
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.structureTags
                  .map((e) => _tag(e)) // reuse your existing tag
                  .toList(),
            )),
          ],
        ),
            ),
      );
  }

  Widget _structureRow(String title, String level) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // 🔹 LEFT → ICON
          _statusIcon(level),

          const SizedBox(width: 12),

          // 🔹 RIGHT → TEXT BLOCK
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // metric name
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                // level
                Text(
                  level,
                  style: TextStyle(
                    color: _levelColor(level),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case "strong":
        return Colors.green;
      case "medium":
        return Colors.orange;
      case "weak":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Icon _statusIcon(String level) {
    switch (level.toLowerCase()) {
      case "strong":
        return const Icon(Icons.check_circle, color: Colors.green, size: 18);

      case "medium":
        return const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 18);

      case "weak":
        return const Icon(Icons.cancel, color: Colors.red, size: 18);

      default:
        return const Icon(Icons.circle, color: Colors.grey, size: 18);
    }
  }

  Widget _strategyCardCustom({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return
      ParallaxCard(
        child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF111827).withOpacity(0.7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 ICON ROW (CENTERED)
            Center(
              child: Icon(
                icon,
                size: 36, // 🔥 INCREASED SIZE
                color: const Color(0xFF06B6D4),
              ),
            ),

            const SizedBox(height: 16),

            // 🔥 TITLE (CENTERED)
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 18),

            child,
          ],
        ),
            ),
      );
  }


  Widget _strategySection() {
    return Column(
      children: [
        _strategyCardCustom(
          icon: Icons.account_balance_wallet_rounded,
          title: "Business Model",
          child: _businessModelContent(),
        ),

        const SizedBox(height: 16),

        _strategyCardCustom(
          icon: Icons.campaign_rounded,
          title: "Marketing Strategy",
          child: _marketingContent(),
        ),


        const SizedBox(height: 16),

        _strategyCardCustom(
          icon: Icons.rocket_launch_rounded,
          title: "Launch Roadmap",
          child: _launchRoadmap(),
        ),
      ],
    );
  }
  Widget _businessModelContent() {
    final items = [
      "Subscription-based model",
      "Commission per validation",
      "Premium AI insights",
    ];

    return Column(
      children: items.map((e) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            e,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14, // 🔥 INCREASED
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _marketingContent() {
    final points = [
      "University ambassador programs",
      "Social media campaigns",
      "AI demo webinars",
    ];

    return Column(
      children: List.generate(points.length, (index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,  // 🔥 BIGGER
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF06B6D4),
                    shape: BoxShape.circle,
                  ),
                ),
                if (index != points.length - 1)
                  Container(
                    width: 2,
                    height: 36, // 🔥 LONGER LINE
                    color: Colors.grey,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  points[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // 🔥 INCREASED
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _launchRoadmap() {
    final steps = [
      "University pilot launch",
      "City-wide expansion",
      "Global AI rollout",
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4F46E5),
                    shape: BoxShape.circle,
                  ),
                ),
                if (index != steps.length - 1)
                  Container(
                    width: 2,
                    height: 36,
                    color: Colors.grey,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Text(
                  steps[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // 🔥 MATCHED
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }













  Widget _finalVerdict(ResultController c) {
    return
      ParallaxCard(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔥 HEADER
              const Text(
                "Final Verdict",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 18),

              // 🔥 MAIN VERDICT TILE (BIG)
              _primaryVerdictTile(
                verdict: c.finalVerdict.value,
                explanation: c.finalExplanation.value,
                score: c.score.value,
              ),

              const SizedBox(height: 14),

              // 🔥 IMPROVEMENTS (DYNAMIC)
              ...c.improvements.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _verdictTile(
                    title: "Improvement",
                    value: item,
                    subtitle: "Recommended optimization",
                    color: const Color(0xFF06B6D4),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
  }
  Widget _primaryVerdictTile({
    required String verdict,
    required String explanation,
    required int score,
  }) {
    final color = resolveScoreColor(score);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        color: Colors.white.withOpacity(0.06),

        border: Border.all(
          color: color.withOpacity(0.35),
          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.22),
            blurRadius: 22,
            spreadRadius: -3,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔥 TOP ROW
          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "AI DECISION",
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(),

              // 🔥 SCORE CHIP (IMPORTANT ADD)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$score%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 🔥 VERDICT
          Text(
            verdict,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          // 🔥 EXPLANATION
          Text(
            explanation,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Color resolveScoreColor(int score) {
    if (score >= 75) {
      return const Color(0xFF22C55E); // green (clear success)
    } else if (score >= 50) {
      return const Color(0xFFF59E0B); // amber (improvable)
    } else {
      return const Color(0xFF38BDF8); // blue (safe neutral, not negative)
    }
  }

  Widget _verdictTile({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),

        border: Border.all(
          color: color.withOpacity(0.25),
        ),

        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 18,
            spreadRadius: -2,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔥 LEFT ACCENT BAR
          Container(
            width: 4,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _chip(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("$title: $value",
          style: const TextStyle(color: Colors.white)),
    );
  }


  Widget _actionButtons() {
    return Row(
      children: [

        // 🔥 PRIMARY BUTTON (EXPANDED)
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.ANALYSIS, arguments: Get.arguments);

            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ),
              ),
              child: const Center(
                child: Text(
                  "Improve Idea",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // 🔥 SAVE BUTTON (TOGGLE)
        Obx(() => _iconButton(
          icon: controller.isSaved.value
              ? Icons.bookmark
              : Icons.bookmark_border,
          onTap: controller.toggleSave,
          active: controller.isSaved.value,
        )),

        const SizedBox(width: 10),

        // 🔥 COMPARE BUTTON
        _iconButton(
          icon: Icons.compare_arrows,
          onTap: () {
            controller.compareIdea(); // make sure method exists
          },
        ),
      ],
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: active
              ? const Color(0x2206B6D4)
              : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active
                ? const Color(0xFF06B6D4)
                : Colors.white24,
          ),
        ),
        child: Icon(
          icon,
          color: active
              ? const Color(0xFF06B6D4)
              : Colors.white70,
        ),
      ),
    );
  }


  Widget _animatedCard({required int index, required Widget child}) {
    return Obx(() {
      final isVisible = controller.visibleCards.value >= index;

      return AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: isVisible ? 1 : 0,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 400),
          offset: isVisible ? Offset.zero : const Offset(0, 0.1),
          child: child,
        ),
      );
    });
  }

  Widget _strategySkeleton() {
    return Column(
      children: [
        _skeletonCard(),
        _skeletonCard(),
        _skeletonCard(),
      ],
    );
  }

  Widget _skeletonCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const SkeletonBox(height: 36, width: 36),
          const SizedBox(height: 16),
          const SkeletonBox(height: 16, width: 140),
          const SizedBox(height: 20),
          const SkeletonBox(height: 14, width: double.infinity),
          const SizedBox(height: 10),
          const SkeletonBox(height: 14, width: double.infinity),
          const SizedBox(height: 10),
          const SkeletonBox(height: 14, width: double.infinity),
        ],
      ),
    );
  }



}