import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:startup_lense/core/constants/app_colors.dart';
import 'package:startup_lense/modules/detailed_analysis/model/financial_model.dart';
import 'package:startup_lense/modules/detailed_analysis/model/market_model.dart';
import 'package:startup_lense/modules/detailed_analysis/model/risk_matrix_model.dart';
import 'package:startup_lense/modules/detailed_analysis/model/structure_model.dart';

class DetailedAnalysisController extends GetxController {
  // 🔷 STATE
  final selectedIndex = 0.obs;
  bool _isTabAnimating = false;
  // 🔥 TAB-BASED ANIMATION CONTROL
  final activeTabIndex = 0.obs;

  // 🔥 ANIMATION TRIGGER FLAG
  final triggerMarketAnimation = false.obs;

  RxBool isSaved = false.obs;

  void toggleSave() {
    isSaved.value = !isSaved.value;
  }

  // 🔥 DUMMY DATA
  final marketData = MarketModel(
    title: "Demand vs Competition",
    description:
    "High demand density in the North-East quadrant remains underserved by current legacy players.",
    sentiment: "Bullish Growth (+14.2%)",
    tam: "\$1.42 Billion",
    demand: 0.88,
    competition: 0.32,
    scalability: 0.94,
  ).obs;

  final financialData = FinancialModel(
    capex: 280000,
    burnRate: "18.5k/mo",
    roi: "22 Months",
    confidence: 96.8,
  ).obs;

  final riskMatrix = [
    RiskMatrixModel(
      impact: "HIGH IMPACT",
      probability: "LOW PROBABILITY",
      title: "Operational Failure",
      icon: Icons.settings_suggest,
      color: Colors.orange,
    ),
    RiskMatrixModel(
      impact: "HIGH IMPACT",
      probability: "HIGH PROBABILITY",
      title: "Market Rejection",
      icon: Icons.error_outline,
      color: Colors.redAccent,
    ),
    RiskMatrixModel(
      impact: "LOW IMPACT",
      probability: "LOW PROBABILITY",
      title: "Minor UX Friction",
      icon: Icons.design_services,
      color: Colors.green,
    ),
    RiskMatrixModel(
      impact: "LOW IMPACT",
      probability: "HIGH PROBABILITY",
      title: "User Drop-off",
      icon: Icons.trending_down,
      color: AppColors.cyan,
    ),
  ].obs;



  final strengths = [
    "Strong problem clarity",
    "Clear value proposition",
    "Scalable idea",
    "High user relevance",
  ].obs;

  final weaknesses = [
    "Limited validation data",
    "Dependency on user adoption",
    "Initial cost uncertainty",
    "Execution complexity",
  ].obs;

  final opportunities = [
    "Growing market demand",
    "Low direct competition",
    "Expansion potential",
    "Partnership possibilities",
  ].obs;

  final threats = [
    "Market saturation risk",
    "Competitor entry",
    "User retention challenge",
    "Economic instability",
  ].obs;

  final metricScore = 8.4.obs;

  final coreAlignment = CoreAlignmentModel(
    matchScore: 0.92,
    description:
    "The idea demonstrates a strong alignment between the identified problem and the proposed solution. "
        "Users face clear inefficiencies, and the solution directly addresses those pain points with measurable improvements. "
        "The value proposition is clearly defined and differentiates from existing alternatives. "
        "Market need is validated with observable patterns. "
        "Execution feasibility remains realistic based on current resources. "
        "Overall, the idea shows high potential for adoption and scalability.",
  ).obs;

  // 🔷 CONTROLLERS
  final tabController = ItemScrollController();
  final sectionController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();

  // 🔷 TABS
  final tabs = ["Structure", "Market", "Risk", "Strategy"];

  @override
  void onInit() {
    super.onInit();

    // 👇 Listen to vertical scroll
    itemPositionsListener.itemPositions.addListener(_onScroll);

    // 👇 Delay initial jump (prevents attach crash)
    Future.delayed(const Duration(milliseconds: 300), () {
      if (tabController.isAttached) {
        tabController.jumpTo(index: selectedIndex.value);
      }
    });
  }

  // 🔷 SCROLL SYNC (SECTION → TAB)
  void _onScroll() {
    if (_isTabAnimating) return;

    final positions = itemPositionsListener.itemPositions.value;

    if (positions.isEmpty) return;

    final firstVisible = positions
        .where((pos) => pos.itemTrailingEdge > 0)
        .reduce((min, pos) =>
    pos.itemLeadingEdge < min.itemLeadingEdge ? pos : min);

    final newIndex = firstVisible.index;

    if (selectedIndex.value != newIndex) {
      selectedIndex.value = newIndex;

      // 🔥 ADD THIS BLOCK
      if (newIndex == 1) { // 1 = Market tab
        triggerMarketAnimation.value = false;

        Future.delayed(const Duration(milliseconds: 120), () {
          triggerMarketAnimation.value = true;
        });
      }

      // 👇 existing tab sync
      if (tabController.isAttached) {
        tabController.scrollTo(
          index: newIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  Future<void> onTabTap(int index) async {
    selectedIndex.value = index;

    _isTabAnimating = true;

    if (sectionController.isAttached) {
      await sectionController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    _isTabAnimating = false;

    // 🔥 ADD THIS BLOCK
    if (index == 1) {
      triggerMarketAnimation.value = false;

      await Future.delayed(const Duration(milliseconds: 120));

      triggerMarketAnimation.value = true;
    }
  }
  @override
  void onClose() {
    itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.onClose();
  }



}
