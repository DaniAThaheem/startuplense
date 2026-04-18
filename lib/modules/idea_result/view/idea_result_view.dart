import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:startup_lense/modules/idea_result/controller/idea_result-controller.dart';
import 'package:startup_lense/modules/idea_result/widgets/animated_score_ring.dart';
import '../widgets/market_card.dart';
import '../widgets/risk_card.dart';
import '../widgets/score_card.dart';
import '../widgets/strategy_card.dart';
import '../widgets/structure_card.dart';
import '../widgets/verdict_card.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResultController());

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: _appBar(),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _animatedCard(index: 1, child: _scoreCard(controller)),
              const SizedBox(height: 20),

              _animatedCard(index: 2, child: _marketCard(controller)),
              const SizedBox(height: 20),

              _animatedCard(index: 3, child: _riskCard(controller)),
              const SizedBox(height: 20),

              _animatedCard(index: 4, child: _structureCard(controller)),
              const SizedBox(height: 20),

              _animatedCard(index: 5, child: _strategyCard(controller)),
              const SizedBox(height: 20),

              _animatedCard(index: 6, child: _finalVerdict(controller)),
              const SizedBox(height: 30),

              _actionButtons(),




            ],

          ),
        );

      }),
    );

  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0B0F19),
      elevation: 0,
      title: const Text("Evaluation Report"),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text("Export"),
        )
      ],
    );
  }

  Widget _scoreCard(ResultController c) {
    return Container(
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
    );
  }

  Widget _marketCard(ResultController c) {
    return _cardWrapper(
      title: "MARKET INTELLIGENCE",
      child: Column(
        children: [
          _metricRow("Demand", c.demand.value),
          _metricRow("Competition", c.competition.value),
          _metricRow("Saturation", c.saturation.value),

          const SizedBox(height: 10),

          Text(c.marketInsight.value,
              style: const TextStyle(color: Colors.white70)),

          const SizedBox(height: 10),

          _tags(c.marketTags),
        ],
      ),
    );
  }

  Widget _riskCard(ResultController c) {
    return _cardWrapper(
      title: "RISK MATRIX",
      child: Column(
        children: [
          _metricRow("Market Risk", c.marketRisk.value),
          _metricRow("Financial Risk", c.financialRisk.value),
          _metricRow("Technical Risk", c.technicalRisk.value),

          const SizedBox(height: 10),

          Text(c.riskInsight.value,
              style: const TextStyle(color: Colors.white70)),

          const SizedBox(height: 10),

          _tags(c.riskTags),
        ],
      ),
    );
  }

  Widget _structureCard(ResultController c) {
    return _cardWrapper(
      title: "STRUCTURE VALIDATION",
      child: Column(
        children: [
          _metricRow("Problem", c.problem.value),
          _metricRow("Value Prop", c.valueProp.value),
          _metricRow("Revenue", c.revenue.value),

          const SizedBox(height: 10),

          _tags(c.structureTags),
        ],
      ),
    );
  }

  Widget _strategyCard(ResultController c) {
    return _cardWrapper(
      title: "STRATEGY ENGINE",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _simpleBlock("Business Model", c.businessModel.value),
          _simpleBlock("Launch", c.launchPhase.value),
          _simpleBlock("Marketing", c.marketing.value),

          const SizedBox(height: 10),

          _tags(c.strategyTags),
        ],
      ),
    );
  }

  Widget _finalVerdict(ResultController c) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("FINAL DECISION",
              style: TextStyle(color: Colors.white70)),

          const SizedBox(height: 10),

          Text(
            c.finalVerdict.value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          Text(c.finalExplanation.value,
              style: const TextStyle(color: Colors.white70)),

          const SizedBox(height: 14),

          _tags(c.improvements),
        ],
      ),
    );
  }


  Widget _actionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
            ),
          ),
          child: const Center(
            child: Text(
              "Improve Idea & Re-run",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(child: _secondaryBtn("Save")),
            const SizedBox(width: 10),
            Expanded(child: _secondaryBtn("Compare")),
          ],
        )
      ],
    );
  }


  Widget _cardWrapper({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white38, fontSize: 12)),

          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _metricRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.cyan)),
        ],
      ),
    );
  }

  Widget _tags(List<String> tags) {
    return Wrap(
      spacing: 8,
      children: tags.map((t) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyan),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(t,
              style: const TextStyle(color: Colors.cyan, fontSize: 12)),
        );
      }).toList(),
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

  Widget _simpleBlock(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text("$title: $value",
          style: const TextStyle(color: Colors.white70)),
    );
  }

  Widget _secondaryBtn(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(text,
            style: const TextStyle(color: Colors.white70)),
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


}