import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:startup_lense/core/constants/app_colors.dart';
import 'package:startup_lense/modules/detailed_analysis/model/financial_model.dart';
import 'package:startup_lense/modules/detailed_analysis/model/market_model.dart';
import 'package:startup_lense/modules/detailed_analysis/model/risk_matrix_model.dart';
import 'package:startup_lense/modules/detailed_analysis/model/structure_model.dart';

class DetailedAnalysisController extends GetxController {

  // ─── STATE ───────────────────────────────────────────────────────────────
  final selectedIndex          = 0.obs;
  final isSaved                = false.obs;
  final isLoading              = true.obs;
  final triggerMarketAnimation = false.obs;
  bool _isTabAnimating         = false;

  // ─── OBSERVABLES ─────────────────────────────────────────────────────────
  final marketData = MarketModel(
    title: '', description: '', sentiment: '',
    tam: '', demand: 0, competition: 0, scalability: 0,
  ).obs;

  final financialData = FinancialModel(
    capex: 0, burnRate: '', roi: '', confidence: 0,
  ).obs;

  final riskMatrix    = <RiskMatrixModel>[].obs;
  final strengths     = <String>[].obs;
  final weaknesses    = <String>[].obs;
  final opportunities = <String>[].obs;
  final threats       = <String>[].obs;
  final metricScore   = 0.0.obs;
  final launchPhases  = <Map<String, dynamic>>[].obs;

  final coreAlignment = CoreAlignmentModel(
    matchScore: 0, description: '',
  ).obs;

  // ─── CONTROLLERS ─────────────────────────────────────────────────────────
  final tabController         = ItemScrollController();
  final sectionController     = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();
  final tabs                  = ["Structure", "Market", "Risk", "Strategy"];

  // ─── LIFECYCLE ───────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    itemPositionsListener.itemPositions.addListener(_onScroll);

    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      _mapFirestoreDoc(args);
    }

    isLoading.value = false;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (tabController.isAttached) {
        tabController.jumpTo(index: 0);
      }
    });
  }

  // ─── MAP FIRESTORE DOCUMENT → OBSERVABLES ────────────────────────────────
  void _mapFirestoreDoc(Map<String, dynamic> doc) {
    final aiResult   = _map(doc,      'aiResult');
    final evaluation = _map(aiResult, 'evaluation');
    final market     = _map(aiResult, 'market');
    final risk       = _map(aiResult, 'risk');
    final strategy   = _map(aiResult, 'strategy');
    final swot       = _map(risk,     'swot');

    // ── Market ───────────────────────────────────────────────────────────────
    final signals = _joinList(market['marketSignals']);
    marketData.value = MarketModel(
      title:       "Demand vs Competition",
      description: signals.isNotEmpty
          ? signals
          : (market['marketInsight'] as String? ?? ''),
      sentiment:   market['marketSentiment']  as String? ?? '',
      tam:         market['tam']              as String? ?? '',
      demand:      _levelToDouble(market['demandLevel']),
      competition: _levelToDouble(market['competitionLevel']),
      scalability: _levelToDouble(market['saturationLevel'], invert: true),
    );

    // ── Financial ────────────────────────────────────────────────────────────
    financialData.value = FinancialModel(
      capex:      (strategy['capex'] as num?)?.toDouble() ?? 0,
      burnRate:   strategy['burnRate']   as String? ?? '',
      roi:        strategy['roiHorizon'] as String? ?? '',
      confidence: ((evaluation['coreAlignmentScore'] as num?)?.toDouble() ?? 0) * 100,
    );

    // ── SWOT ─────────────────────────────────────────────────────────────────
    _assignList(strengths,     swot['strengths']);
    _assignList(weaknesses,    swot['weaknesses']);
    _assignList(opportunities, swot['opportunities']);
    _assignList(threats,       swot['threats']);

    // ── Core Alignment ───────────────────────────────────────────────────────
    coreAlignment.value = CoreAlignmentModel(
      matchScore:  (evaluation['coreAlignmentScore'] as num?)?.toDouble() ?? 0,
      description: evaluation['coreAlignmentDescription'] as String? ?? '',
    );

    // ── Metric Score ─────────────────────────────────────────────────────────
    final ms = evaluation['metricScore'] ?? aiResult['metricScore'];
    if (ms != null) metricScore.value = (ms as num).toDouble();

    // ── Risk Matrix ───────────────────────────────────────────────────────────
    riskMatrix.assignAll(_buildRiskMatrix(risk));

    // ── Launch Phases ─────────────────────────────────────────────────────────
    final phases = strategy['launchPhases'];
    if (phases is List) {
      launchPhases.assignAll(
        phases.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
      );
    }
  }

  // ─── BUILD RISK MATRIX ────────────────────────────────────────────────────
  List<RiskMatrixModel> _buildRiskMatrix(Map<String, dynamic> risk) {
    return [
      RiskMatrixModel(
        impact:      "FINANCIAL RISK",
        probability: risk['financialRisk']        as String? ?? '',
        title:       "Capital Deficiency",
        icon:        Icons.account_balance_wallet_outlined,
        color:       _riskColor(risk['financialRisk'] as String?),
      ),
      RiskMatrixModel(
        impact:      "MARKET RISK",
        probability: risk['marketRisk']            as String? ?? '',
        title:       "Market Entry",
        icon:        Icons.show_chart,
        color:       _riskColor(risk['marketRisk'] as String?),
      ),
      RiskMatrixModel(
        impact:      "TECHNICAL RISK",
        probability: risk['technicalRisk']         as String? ?? '',
        title:       "Tech Complexity",
        icon:        Icons.developer_mode,
        color:       _riskColor(risk['technicalRisk'] as String?),
      ),
      RiskMatrixModel(
        impact:      "MARKET ENTRY",
        probability: risk['marketEntryDifficulty'] as String? ?? '',
        title:       "Entry Difficulty",
        icon:        Icons.lock_outline,
        color:       _riskColor(risk['marketEntryDifficulty'] as String?),
      ),
    ];
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────
  Color _riskColor(String? level) {
    switch ((level ?? '').toLowerCase()) {
      case 'high':   return Colors.redAccent;
      case 'medium': return Colors.orange;
      case 'low':    return Colors.green;
      default:       return AppColors.cyan;
    }
  }

  Map<String, dynamic> _map(Map<String, dynamic> src, String key) {
    final v = src[key];
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

  String _joinList(dynamic list) {
    if (list is List) return list.join(' · ');
    return '';
  }

  void _assignList(RxList<String> target, dynamic source) {
    if (source is List && source.isNotEmpty) {
      target.assignAll(List<String>.from(source));
    }
  }

  // ─── SAVE TOGGLE ─────────────────────────────────────────────────────────
  void toggleSave() => isSaved.value = !isSaved.value;

  // ─── SCROLL SYNC (SECTION → TAB) ─────────────────────────────────────────
  void _onScroll() {
    if (_isTabAnimating) return;

    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final firstVisible = positions
        .where((p) => p.itemTrailingEdge > 0)
        .reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b);

    final newIndex = firstVisible.index;
    if (selectedIndex.value != newIndex) {
      selectedIndex.value = newIndex;
      _maybeFireMarketAnimation(newIndex);

      if (tabController.isAttached) {
        tabController.scrollTo(
          index: newIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  // ─── TAB TAP ─────────────────────────────────────────────────────────────
  Future<void> onTabTap(int index) async {
    selectedIndex.value = index;
    _isTabAnimating     = true;

    if (sectionController.isAttached) {
      await sectionController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    _isTabAnimating = false;
    _maybeFireMarketAnimation(index);
  }

  // ─── MARKET ANIMATION TRIGGER ─────────────────────────────────────────────
  void _maybeFireMarketAnimation(int index) {
    if (index == 1) {
      triggerMarketAnimation.value = false;
      Future.delayed(
        const Duration(milliseconds: 120),
            () => triggerMarketAnimation.value = true,
      );
    }
  }

  // ─── CLEANUP ─────────────────────────────────────────────────────────────
  @override
  void onClose() {
    itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.onClose();
  }
}