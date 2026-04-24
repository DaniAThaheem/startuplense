import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:startup_lense/core/constants/app_colors.dart';
import 'package:startup_lense/modules/detailed_analysis/model/financial_model.dart';
import 'package:startup_lense/modules/detailed_analysis/model/risk_matrix_model.dart';
import 'package:startup_lense/modules/detailed_analysis/view/widgets/analysis_cards.dart';
import 'package:startup_lense/modules/detailed_analysis/view/widgets/animate_metric_bar.dart';
import '../controller/detailed_analysis_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:ui';
import 'package:percent_indicator/percent_indicator.dart';

class DetailedAnalysisView extends GetView<DetailedAnalysisController> {
  const DetailedAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.25),
        elevation: 0,
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
        ),
        leading: const BackButton(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gradientText("Detailed Analysis"),
            const SizedBox(height: 2),
            const Text(
              "Detailed AI Breakdown",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [

          // ── BOOKMARK ────────────────────────────────────────────────────
          Obx(() => IconButton(
            onPressed: controller.toggleSave,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: controller.isSaved.value
                  ? const Icon(Icons.bookmark,
                  key: ValueKey("filled"), color: AppColors.cyan)
                  : const Icon(Icons.bookmark_border,
                  key: ValueKey("outline"), color: Colors.white),
            ),
          )),

          // ── SHARE ────────────────────────────────────────────────────────
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: Colors.white),
          ),

          const SizedBox(width: 12),
        ],
      ),

      // ── BODY ──────────────────────────────────────────────────────────────
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.cyan),
          );
        }
        return Column(
          children: [
            _tabs(),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: controller.sectionController,
                itemPositionsListener: controller.itemPositionsListener,
                itemCount: controller.tabs.length,
                padding: const EdgeInsets.only(bottom: 40),
                itemBuilder: (context, index) {
                  return _sectionWrapper(child: _buildSection(index));
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  // ===================== TABS =====================

  Widget _tabs() {
    return SizedBox(
      height: 65,
      child: ScrollablePositionedList.builder(
        itemScrollController: controller.tabController,
        scrollDirection: Axis.horizontal,
        itemCount: controller.tabs.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (_, index) {
          return Obx(() {
            final isActive = controller.selectedIndex.value == index;

            return GestureDetector(
              onTap: () => controller.onTabTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.cyan.withOpacity(0.18)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isActive
                        ? AppColors.cyan
                        : Colors.white.withOpacity(0.05),
                  ),
                ),
                child: SizedBox(
                  width: 60,
                  child: Text(
                    controller.tabs[index],
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white60,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // ===================== SECTION WRAPPER =====================

  Widget _sectionWrapper({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: child,
    );
  }

  // ===================== SECTION BUILDER =====================

  Widget _buildSection(int index) {
    switch (index) {
      case 0: return _structureSection();
      case 1: return _marketSection();
      case 2: return _riskSection();
      case 3: return _strategySection();
      default: return const SizedBox();
    }
  }

  // ===================== STRUCTURE SECTION =====================

  Widget _structureSection() {
    return Column(
      children: [
        coreAlignmentCard(),
        analysisMetricCard(),
      ],
    );
  }

  // ===================== MARKET SECTION =====================

  Widget _marketSection() {
    return Column(
      children: [
        glassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              marketLandscapeCard(),
            ],
          ),
        ),
      ],
    );
  }

  // ===================== RISK SECTION =====================

  Widget _riskSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          riskMatrixCard(),

          Obx(() => Column(
            children: [
              swotCard(
                icon: Icons.trending_up,
                title: "Strengths",
                color: Colors.green,
                points: controller.strengths,
              ),
              swotCard(
                icon: Icons.warning_amber,
                title: "Weaknesses",
                color: Colors.orange,
                points: controller.weaknesses,
              ),
              swotCard(
                icon: Icons.lightbulb_outline,
                title: "Opportunities",
                color: AppColors.cyan,
                points: controller.opportunities,
              ),
              swotCard(
                icon: Icons.security,
                title: "Threats",
                color: Colors.redAccent,
                points: controller.threats,
              ),
            ],
          )),
        ],
      ),
    );
  }

  // ===================== STRATEGY SECTION =====================

  Widget _strategySection() {
    return Obx(() {
      final data = controller.financialData.value;
      return Column(
        children: [
          glassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quarterly Growth Milestones",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                timeline(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          financialSummaryCard(data),
        ],
      );
    });
  }

  // ===================== CORE ALIGNMENT CARD =====================

  Widget coreAlignmentCard() {
    return Obx(() {
      final data = controller.coreAlignment.value;

      // derive match text from score e.g. 0.88 → "88% Match"
      final matchText =
          "${(data.matchScore * 100).toStringAsFixed(0)}% Match";

      return ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Stack(
              children: [

                // ── WATERMARK ─────────────────────────────────────────────
                Positioned(
                  right: -10,
                  top: -10,
                  child: Opacity(
                    opacity: 0.05,
                    child: Icon(
                      Icons.bar_chart_rounded,
                      size: 120,
                      color: AppColors.cyan,
                    ),
                  ),
                ),

                // ── CONTENT ───────────────────────────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Core Alignment",
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Center(
                      child: Text(
                        "Problem–Solution Fit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconBlock(
                          icon: Icons.report_problem_outlined,
                          label: "Pain Points",
                          color: Colors.orange,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.cyan),
                          ),
                          child: Text(
                            matchText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _iconBlock(
                          icon: Icons.lightbulb_outline,
                          label: "Value Prop",
                          color: AppColors.cyan,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      data.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.7,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _iconBlock({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(45),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  // ===================== ANALYSIS METRIC CARD =====================

  Widget analysisMetricCard() {
    return Obx(() {
      final score = controller.metricScore.value;

      return ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ANALYSIS METRIC",
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                CircularPercentIndicator(
                  radius: 85.0,
                  lineWidth: 14.0,
                  percent: (score / 10).clamp(0.0, 1.0),
                  animation: true,
                  animationDuration: 900,
                  circularStrokeCap: CircularStrokeCap.round,
                  linearGradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                  ),
                  backgroundColor: Colors.white.withOpacity(0.05),
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        score.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Strength Score",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "VALUE PROP AUTHORITY",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Your value proposition demonstrates strong clarity and differentiation in solving a real-world user problem.",
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.6,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ===================== SWOT CARD =====================

  Widget swotCard({
    required IconData icon,
    required String title,
    required Color color,
    required List<String> points,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.35), Colors.transparent],
                    ),
                    border: Border.all(color: color.withOpacity(0.5)),
                  ),
                  child: Icon(icon, color: color, size: 40),
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: Stack(
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1.2
                          ..color = color.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: points.map((p) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, right: 8),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            p,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.6,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== RISK MATRIX CARD =====================

  Widget riskMatrixCard() {
    return Obx(() {
      final data = controller.riskMatrix;

      return ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Strategic Risk Matrix",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 18),

                GridView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (_, index) => _riskCell(data[index]),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _riskCell(RiskMatrixModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF111827),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${item.impact} /",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.probability,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),

          Expanded(
            flex: 2,
            child: Center(
              child: Icon(item.icon, color: item.color, size: 43),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: item.color,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ===================== TIMELINE =====================

  Widget timeline() {
    final phaseColors = [Colors.blueAccent, AppColors.cyan, Colors.greenAccent];

    return Obx(() {
      final phases = controller.launchPhases;
      if (phases.isEmpty) return const SizedBox();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(phases.length, (i) {
          final p = phases[i];
          return _timelineItem(
            date:     "${p['phase'] ?? ''} · ${p['quarter'] ?? ''}",
            title:    p['title']       as String? ?? '',
            desc:     p['description'] as String? ?? '',
            color:    phaseColors[i % phaseColors.length],
            isActive: i == 0,
            isLast:   i == phases.length - 1,
          );
        }),
      );
    });
  }

  Widget _timelineItem({
    required String date,
    required String title,
    required String desc,
    required Color color,
    required bool isActive,
    required bool isLast,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── NODE + LINE ────────────────────────────────────────────────
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isActive
                      ? LinearGradient(
                    colors: [color, color.withOpacity(0.6)],
                  )
                      : null,
                  color: isActive ? null : Colors.transparent,
                  border: Border.all(color: color, width: 2),
                  boxShadow: isActive
                      ? [BoxShadow(
                    color: color.withOpacity(0.6),
                    blurRadius: 14,
                    spreadRadius: 2,
                  )]
                      : [],
                ),
                child: isActive
                    ? const Icon(Icons.flag, size: 14, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Container(
                  width: 4,
                  height: 90,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 18),

          // ── CONTENT CARD ───────────────────────────────────────────────
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isActive
                      ? color.withOpacity(0.6)
                      : Colors.white.withOpacity(0.06),
                ),
                boxShadow: isActive
                    ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 20)]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== MARKET LANDSCAPE =====================

  Widget marketLandscapeCard() {
    return Obx(() {
      final data = controller.marketData.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text("MARKET LANDSCAPE",
              style: TextStyle(color: AppColors.cyan, fontSize: 14)),

          const SizedBox(height: 10),

          Text(data.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),

          const SizedBox(height: 15),

          Text(data.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),

          const SizedBox(height: 18),

          marketInfoTile(
            label: "Market Sentiment",
            value: data.sentiment,
            accentColor: Colors.greenAccent,
          ),

          const SizedBox(height: 12),

          marketInfoTile(
            label: "Addressable TAM",
            value: data.tam,
            accentColor: Colors.purpleAccent,
          ),

          const SizedBox(height: 25),

          metricBar(
            title: "User Demand",
            label: "${(data.demand * 100).toStringAsFixed(0)}%",
            value: data.demand,
            color: Colors.cyan,
          ),

          const SizedBox(height: 25),

          metricBar(
            title: "Active Competition",
            label: "${(data.competition * 100).toStringAsFixed(0)}%",
            value: data.competition,
            color: Colors.orange,
          ),

          const SizedBox(height: 25),

          metricBar(
            title: "Scalability",
            label: "${(data.scalability * 100).toStringAsFixed(0)}%",
            value: data.scalability,
            color: Colors.greenAccent,
          ),
        ],
      );
    });
  }

  Widget metricBar({
    required String title,
    required String label,
    required double value,
    required Color color,
  }) {
    return Obx(() {
      final animate = controller.triggerMarketAnimation.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white)),
              Text(label, style: const TextStyle(color: Colors.white60)),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedMetricBar(value: value, color: color, animate: animate),
            ],
          ),
        ],
      );
    });
  }

  Widget marketInfoTile({
    required String label,
    required String value,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 58,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== FINANCIAL SUMMARY =====================

  Widget financialSummaryCard(FinancialModel data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF3730A3),
            Color(0xFF06B6D4),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "PROJECTED OUTCOME",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Financial Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          _metricRow("Initial CAPEX", "PKR ${_formatNumber(data.capex)}"),
          _divider(),
          _metricRow("Burn Rate (Est)", data.burnRate),
          _divider(),
          _metricRow("ROI Horizon", data.roi, highlight: true),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.greenAccent.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.greenAccent,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "AI Confidence Score: ${data.confidence.toStringAsFixed(1)}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricRow(String title, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? Colors.greenAccent : Colors.white,
              fontSize: highlight ? 16 : 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.white.withOpacity(0.15), thickness: 0.8);
  }

  // ===================== HELPERS =====================

  Widget gradientText(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.cyan, AppColors.primaryText],
      ).createShader(bounds),
      child: const Text(
        "Detailed Analysis",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    } else if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(0)}K";
    }
    return value.toStringAsFixed(0);
  }
}