import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:startup_lense/modules/idea_result/controller/idea_result-controller.dart';
import 'package:startup_lense/modules/idea_result/widgets/animated_score_ring.dart';
import 'package:startup_lense/modules/idea_result/widgets/parallax_card.dart';
import 'package:startup_lense/modules/idea_result/widgets/skeleton_box.dart';
import 'package:startup_lense/routes/app_routes.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  // ── Design tokens ─────────────────────────────────────────
  static const _bg       = Color(0xFF0B0F19);
  static const _surface  = Color(0xFF111827);
  static const _surface2 = Color(0xFF1F2937);
  static const _cyan     = Color(0xFF06B6D4);
  static const _indigo   = Color(0xFF4F46E5);
  static const _border   = Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    Get.put(ResultController());
    return Scaffold(
      backgroundColor: _bg,
      appBar: _appBar(),
      body: SafeArea(
        child: Obx(() => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            children: [
              _animatedCard(index: 1, child: _scoreCard()),
              _animatedCard(index: 2, child: Obx(() => controller.isLoading.value
                  ? _skeleton() : _marketCard())),
              _animatedCard(index: 3, child: Obx(() => controller.isLoading.value
                  ? _skeleton() : _riskCard())),
              _animatedCard(index: 4, child: Obx(() => controller.isLoading.value
                  ? _skeleton() : _structureCard())),
              _animatedCard(index: 5, child: Obx(() => controller.isLoading.value
                  ? _skeleton() : _strategySection())),
              _animatedCard(index: 6, child: Obx(() => controller.isLoading.value
                  ? _skeleton() : _finalVerdict())),
              const SizedBox(height: 12),
              Obx(() => controller.isLoading.value
                  ? _skeleton() : _actionButtons()),
            ],
          ),
        )),
      ),
    );
  }

  // ===================== APP BAR =====================

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: _bg,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      title: ShaderMask(
        shaderCallback: (b) => const LinearGradient(
          colors: [_indigo, _cyan],
        ).createShader(b),
        child: const Text(
          "Evaluation Report",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.white70),
          onPressed: controller.exportPremiumReport,
        ),
      ],
    );
  }

  // ===================== SCORE CARD =====================

  Widget _scoreCard() {
    return _card(
      child: Column(
        children: [
          Obx(() => AnimatedScoreRing(score: controller.score.value)),
          const SizedBox(height: 16),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _chip("Confidence", controller.confidence.value),
              const SizedBox(width: 10),
              _chip("Agreement", controller.agreement.value),
            ],
          )),
          const SizedBox(height: 16),
          Obx(() => Text(
            controller.verdictLine.value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          )),
        ],
      ),
    );
  }

  // ===================== MARKET CARD =====================

  Widget _marketCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _cardHeader(
            icon: Icons.insights_rounded,
            title: "Market Intelligence",
            color: _cyan,
          ),

          const SizedBox(height: 16),

          // ── TAM + Sentiment row ──────────────────────────
          Obx(() => Row(
            children: [
              _infoTile("TAM", controller.tam.value, _indigo),
              const SizedBox(width: 10),
              _infoTile("Sentiment", controller.marketSentiment.value,
                  Colors.greenAccent),
            ],
          )),

          const SizedBox(height: 16),

          // ── 3 metric columns ─────────────────────────────
          Obx(() => Row(
            children: [
              _metricColumn("Demand",      controller.demand.value),
              const SizedBox(width: 10),
              _metricColumn("Competition", controller.competition.value),
              const SizedBox(width: 10),
              _metricColumn("Saturation",  controller.saturation.value),
            ],
          )),

          const SizedBox(height: 16),

          // ── Insight ──────────────────────────────────────
          Obx(() => _insightBlock(controller.marketInsight.value)),

          const SizedBox(height: 14),

          // ── Market signals ────────────────────────────────
          Obx(() {
            if (controller.marketSignals.isEmpty) return const SizedBox();
            return _sectionLabel("Market Signals");
          }),
          const SizedBox(height: 8),
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.marketSignals
                .map((e) => _chipTag(e, Colors.green))
                .toList(),
          )),

          const SizedBox(height: 12),

          // ── Tags ──────────────────────────────────────────
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.marketTags
                .map((e) => _chipTag(e, _cyan))
                .toList(),
          )),
        ],
      ),
    );
  }

  // ===================== RISK CARD =====================

  Widget _riskCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _cardHeader(
            icon: Icons.shield_outlined,
            title: "Risk Matrix",
            color: Colors.orange,
          ),

          const SizedBox(height: 16),

          Obx(() => Column(
            children: [
              _riskRow("Market Risk",    controller.marketRisk.value),
              _divider(),
              _riskRow("Financial Risk", controller.financialRisk.value),
              _divider(),
              _riskRow("Technical Risk", controller.technicalRisk.value),
            ],
          )),

          const SizedBox(height: 16),

          Obx(() => _insightBlock(controller.riskInsight.value)),

          const SizedBox(height: 12),

          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.riskTags
                .map((e) => _chipTag(e, Colors.orange))
                .toList(),
          )),
        ],
      ),
    );
  }

  // ===================== STRUCTURE CARD =====================

  Widget _structureCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _cardHeader(
            icon: Icons.account_tree_outlined,
            title: "Structure Validation",
            color: Colors.purpleAccent,
          ),

          const SizedBox(height: 16),

          Obx(() => Column(
            children: [
              _structureRow("Problem Clarity",   controller.problemStrength.value),
              _divider(),
              _structureRow("Value Proposition", controller.valuePropStrength.value),
              _divider(),
              _structureRow("Audience Clarity",  controller.audienceClarity.value),
            ],
          )),

          const SizedBox(height: 16),

          // ── Problem statement ─────────────────────────────
          Obx(() {
            if (controller.problem.value.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel("Problem Statement"),
                const SizedBox(height: 8),
                _insightBlock(controller.problem.value),
                const SizedBox(height: 12),
              ],
            );
          }),

          // ── Value prop ────────────────────────────────────
          Obx(() {
            if (controller.valueProp.value.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel("Value Proposition"),
                const SizedBox(height: 8),
                _insightBlock(controller.valueProp.value),
                const SizedBox(height: 12),
              ],
            );
          }),

          // ── Key resources ─────────────────────────────────
          Obx(() {
            if (controller.structureTags.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel("Key Resources"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.structureTags
                      .map((e) => _chipTag(e, Colors.purpleAccent))
                      .toList(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ===================== STRATEGY SECTION =====================

  Widget _strategySection() {
    return Column(
      children: [
        _businessModelCard(),
        const SizedBox(height: 14),
        _marketingCard(),
        const SizedBox(height: 14),
        _launchRoadmapCard(),
        const SizedBox(height: 14),
        _financialCard(),
      ],
    );
  }

  // ── Business Model ────────────────────────────────────────
  Widget _businessModelCard() {
    return _strategyCard(
      icon:  Icons.account_balance_wallet_rounded,
      title: "Business Model",
      color: _indigo,
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (controller.businessModel.value.isNotEmpty)
            _strategyItem(
              icon:  Icons.category_outlined,
              label: "Model Type",
              value: controller.businessModel.value,
              color: _indigo,
            ),

          if (controller.pricingStrategy.value.isNotEmpty) ...[
            const SizedBox(height: 10),
            _strategyItem(
              icon:  Icons.attach_money,
              label: "Pricing Strategy",
              value: controller.pricingStrategy.value,
              color: Colors.greenAccent,
            ),
          ],

          if (controller.revenueStreams.isNotEmpty) ...[
            const SizedBox(height: 14),
            _sectionLabel("Revenue Streams"),
            const SizedBox(height: 8),
            ...controller.revenueStreams.map((e) => _bulletItem(e, _cyan)),
          ],
        ],
      )),
    );
  }

  // ── Marketing ─────────────────────────────────────────────
  Widget _marketingCard() {
    return _strategyCard(
      icon:  Icons.campaign_rounded,
      title: "Marketing Strategy",
      color: _cyan,
      child: Obx(() {
        if (controller.marketingChannels.isEmpty) {
          return const Text(
            "No marketing channels available.",
            style: TextStyle(color: Colors.white54),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            controller.marketingChannels.length,
                (i) => _timelineItem(
              text:   controller.marketingChannels[i],
              color:  _cyan,
              isLast: i == controller.marketingChannels.length - 1,
            ),
          ),
        );
      }),
    );
  }

  // ── Launch Roadmap ────────────────────────────────────────
  Widget _launchRoadmapCard() {
    return _strategyCard(
      icon:  Icons.rocket_launch_rounded,
      title: "Launch Roadmap",
      color: Colors.purpleAccent,
      child: Obx(() {
        if (controller.launchPhases.isEmpty) {
          return const Text(
            "No launch phases available.",
            style: TextStyle(color: Colors.white54),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            controller.launchPhases.length,
                (i) {
              final phase = controller.launchPhases[i];
              return _launchPhaseItem(
                phase:       phase['phase']       as String? ?? '',
                quarter:     phase['quarter']     as String? ?? '',
                title:       phase['title']       as String? ?? '',
                description: phase['description'] as String? ?? '',
                isFirst:     i == 0,
                isLast:      i == controller.launchPhases.length - 1,
                color: [
                  Colors.blueAccent,
                  _cyan,
                  Colors.purpleAccent,
                ][i % 3],
              );
            },
          ),
        );
      }),
    );
  }

  // ── Financial ─────────────────────────────────────────────
  Widget _financialCard() {
    return _strategyCard(
      icon:  Icons.bar_chart_rounded,
      title: "Financial Overview",
      color: Colors.greenAccent,
      child: Obx(() => Column(
        children: [
          _financialRow("Initial CAPEX",
              "PKR ${_formatNumber(controller.capex.value)}"),
          _fdivider(),
          _financialRow("Monthly Burn Rate", controller.burnRate.value),
          _fdivider(),
          _financialRow("ROI Horizon", controller.roiHorizon.value,
              highlight: true),
        ],
      )),
    );
  }

  // ===================== FINAL VERDICT =====================

  Widget _finalVerdict() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _cardHeader(
            icon: Icons.verified_outlined,
            title: "Final Verdict",
            color: Colors.greenAccent,
          ),

          const SizedBox(height: 16),

          // ── Primary verdict tile ──────────────────────────
          Obx(() => _primaryVerdictTile(
            verdict:     controller.finalVerdict.value,
            explanation: controller.finalExplanation.value,
            score:       controller.score.value,
          )),

          const SizedBox(height: 16),

          // ── Improvements ──────────────────────────────────
          Obx(() {
            if (controller.improvements.isEmpty) return const SizedBox();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel("Recommended Improvements"),
                const SizedBox(height: 10),
                ...controller.improvements.asMap().entries.map((e) =>
                    _improvementItem(index: e.key + 1, text: e.value)),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ===================== ACTION BUTTONS =====================

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Get.toNamed(
              '/improve-idea',
              arguments: Get.arguments,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [_indigo, _cyan],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _cyan.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_fix_high, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Improve Idea",
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
        Obx(() => _iconButton(
          icon:   controller.isSaved.value
              ? Icons.bookmark
              : Icons.bookmark_border,
          onTap:  controller.toggleSave,
          active: controller.isSaved.value,
        )),
        const SizedBox(width: 10),
        _iconButton(
          icon:  Icons.compare_arrows,
          onTap: controller.compareIdea,
        ),
      ],
    );
  }

  // ===================== REUSABLE COMPONENTS =====================

  // ── Base card ─────────────────────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // ── Strategy card ─────────────────────────────────────────
  Widget _strategyCard({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(icon: icon, title: title, color: color),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  // ── Card header ───────────────────────────────────────────
  Widget _cardHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ── Info tile (TAM / Sentiment) ────────────────────────────
  Widget _infoTile(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value.isNotEmpty ? value : '—',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Metric column ─────────────────────────────────────────
  Widget _metricColumn(String title, String level) {
    final progress = _levelToProgress(level);
    final color    = _levelToColor(level);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 6),
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

  // ── Risk row ──────────────────────────────────────────────
  Widget _riskRow(String metric, String level) {
    final color = _riskColor(level);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              metric,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
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
          ),
        ],
      ),
    );
  }

  // ── Structure row ─────────────────────────────────────────
  Widget _structureRow(String title, String level) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _statusIcon(level),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _levelColor(level).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              level,
              style: TextStyle(
                color: _levelColor(level),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Strategy item ─────────────────────────────────────────
  Widget _strategyItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
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

  // ── Bullet item ───────────────────────────────────────────
  Widget _bulletItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Timeline item (marketing channels) ────────────────────
  Widget _timelineItem({
    required String text,
    required Color color,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Launch phase item ─────────────────────────────────────
  Widget _launchPhaseItem({
    required String phase,
    required String quarter,
    required String title,
    required String description,
    required bool isFirst,
    required bool isLast,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Node + line ─────────────────────────────────────
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.6)],
                ),
                boxShadow: isFirst
                    ? [BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 1,
                )]
                    : [],
              ),
              child: Center(
                child: Icon(
                  isFirst ? Icons.flag_rounded : Icons.radio_button_checked,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 80,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),

        const SizedBox(width: 14),

        // ── Content ─────────────────────────────────────────
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isFirst
                    ? color.withOpacity(0.5)
                    : Colors.white.withOpacity(0.05),
              ),
              boxShadow: isFirst
                  ? [BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 16,
              )]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        phase,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      quarter,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Financial row ─────────────────────────────────────────
  Widget _financialRow(String label, String value,
      {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          Text(
            value.isNotEmpty ? value : '—',
            style: TextStyle(
              color: highlight ? Colors.greenAccent : Colors.white,
              fontSize: highlight ? 15 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ── Insight block ─────────────────────────────────────────
  Widget _insightBlock(String text) {
    if (text.isEmpty) return const SizedBox();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cyan.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cyan.withOpacity(0.12)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          height: 1.6,
        ),
      ),
    );
  }

  // ── Improvement item ──────────────────────────────────────
  Widget _improvementItem({required int index, required String text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cyan.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_indigo, _cyan],
              ),
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Primary verdict tile ──────────────────────────────────
  Widget _primaryVerdictTile({
    required String verdict,
    required String explanation,
    required int score,
  }) {
    final color = _resolveScoreColor(score);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: color.withOpacity(0.06),
        border: Border.all(color: color.withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: -2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$score/100",
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
          Text(
            verdict,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            explanation,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withOpacity(0.4),
        fontSize: 10,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ── Chips ─────────────────────────────────────────────────
  Widget _chip(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        "$title: $value",
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }

  Widget _chipTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ── Icon button ───────────────────────────────────────────
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
          color: active ? _cyan.withOpacity(0.12) : _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? _cyan : Colors.white24,
          ),
        ),
        child: Icon(
          icon,
          color: active ? _cyan : Colors.white70,
        ),
      ),
    );
  }

  // ── Dividers ──────────────────────────────────────────────
  Widget _divider() => Divider(
    color: Colors.white.withOpacity(0.06),
    height: 1,
    thickness: 1,
  );

  Widget _fdivider() => Divider(
    color: Colors.white.withOpacity(0.08),
    height: 1,
  );

  // ── Animated card wrapper ─────────────────────────────────
  Widget _animatedCard({required int index, required Widget child}) {
    return Obx(() {
      final visible = controller.visibleCards.value >= index;
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 450),
        opacity: visible ? 1.0 : 0.0,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 450),
          offset: visible ? Offset.zero : const Offset(0, 0.08),
          child: child,
        ),
      );
    });
  }

  // ── Skeleton ──────────────────────────────────────────────
  Widget _skeleton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonBox(height: 16, width: 120),
          SizedBox(height: 16),
          SkeletonBox(height: 14, width: double.infinity),
          SizedBox(height: 10),
          SkeletonBox(height: 14, width: double.infinity),
          SizedBox(height: 10),
          SkeletonBox(height: 14, width: 200),
        ],
      ),
    );
  }

  // ── Status icon ───────────────────────────────────────────
  Icon _statusIcon(String level) {
    switch (level.toLowerCase()) {
      case 'strong':
      case 'clear':
        return const Icon(Icons.check_circle, color: Colors.green, size: 18);
      case 'medium':
      case 'moderate':
        return const Icon(Icons.warning_amber_rounded,
            color: Colors.orange, size: 18);
      default:
        return const Icon(Icons.cancel, color: Colors.red, size: 18);
    }
  }

  // ── Color helpers ─────────────────────────────────────────
  Color _riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':   return Colors.red;
      case 'medium': return Colors.orange;
      case 'low':    return Colors.green;
      default:       return Colors.grey;
    }
  }

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'strong':
      case 'clear':    return Colors.green;
      case 'medium':
      case 'moderate': return Colors.orange;
      default:         return Colors.red;
    }
  }

  Color _levelToColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':   return Colors.green;
      case 'medium': return Colors.orange;
      case 'low':    return Colors.red;
      default:       return Colors.grey;
    }
  }

  double _levelToProgress(String level) {
    switch (level.toLowerCase()) {
      case 'high':   return 0.85;
      case 'medium': return 0.55;
      case 'low':    return 0.30;
      default:       return 0.0;
    }
  }

  Color _resolveScoreColor(int score) {
    if (score >= 75) return const Color(0xFF22C55E);
    if (score >= 50) return const Color(0xFFF59E0B);
    return const Color(0xFF38BDF8);
  }

  String _formatNumber(double value) {
    if (value >= 1000000) return "${(value / 1000000).toStringAsFixed(1)}M";
    if (value >= 1000)    return "${(value / 1000).toStringAsFixed(0)}K";
    return value.toStringAsFixed(0);
  }
}