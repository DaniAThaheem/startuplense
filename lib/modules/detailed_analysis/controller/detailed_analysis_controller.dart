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
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) loadRealData(args);   // ← add this line
    itemPositionsListener.itemPositions.addListener(_onScroll);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (tabController.isAttached) {
        tabController.jumpTo(index: selectedIndex.value);
      }
    });
  }

  void loadRealData(Map<String, dynamic> args) {
    final market     = _safeMap(args['swot'] != null ? args : null, 'market');
    final risk       = _safeMap(args, 'swot');
    final strategy   = args;
    final evaluation = args;

    // Market data
    marketData.value = MarketModel(
      title:       "Demand vs Competition",
      description: args['marketSignals'] is List
          ? (args['marketSignals'] as List).join(' · ')
          : marketData.value.description,
      sentiment:   args['marketSentiment']  ?? marketData.value.sentiment,
      tam:         args['tam']              ?? marketData.value.tam,
      demand:      _levelToDouble(args['demand']),
      competition: _levelToDouble(args['competition']),
      scalability: _levelToDouble(args['saturation'], invert: true),
    );

    // Financial data
    financialData.value = FinancialModel(
      capex:      (args['capex'] as num?)?.toDouble() ?? 280000,
      burnRate:   args['burnRate']   ?? financialData.value.burnRate,
      roi:        args['roiHorizon'] ?? financialData.value.roi,
      confidence: ((args['coreAlignmentScore'] as num?)?.toDouble() ?? 0.92) * 100,
    );

    // SWOT
    final swot = args['swot'] as Map<String, dynamic>? ?? {};
    final s = swot['strengths']     as List?;
    final w = swot['weaknesses']    as List?;
    final o = swot['opportunities'] as List?;
    final t = swot['threats']       as List?;
    if (s != null && s.isNotEmpty) strengths.assignAll(List<String>.from(s));
    if (w != null && w.isNotEmpty) weaknesses.assignAll(List<String>.from(w));
    if (o != null && o.isNotEmpty) opportunities.assignAll(List<String>.from(o));
    if (t != null && t.isNotEmpty) threats.assignAll(List<String>.from(t));

    // Core alignment
    coreAlignment.value = CoreAlignmentModel(
      matchScore:  (args['coreAlignmentScore'] as num?)?.toDouble() ?? 0.92,
      description: args['coreAlignmentDesc'] ?? coreAlignment.value.description,
    );

    // Metric score
    final ms = args['metricScore'];
    if (ms != null) metricScore.value = (ms as num).toDouble();
  }

  Map<String, dynamic> _safeMap(Map<String, dynamic>? source, String key) {
    if (source == null) return {};
    final v = source[key];
    return v is Map ? Map<String, dynamic>.from(v) : {};
  }

  double _levelToDouble(dynamic level, {bool invert = false}) {
    double v;
    switch ((level as String? ?? '').toLowerCase()) {
      case 'high':   v = 0.85; break;
      case 'medium': v = 0.55; break;
      case 'low':    v = 0.25; break;
      default:       v = 0.50;
    }
    return invert ? (1.0 - v) : v;
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
