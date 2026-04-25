import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:startup_lense/data/agents/agent_runner.dart';
import 'package:startup_lense/data/repositories/improve_repository.dart';
import 'package:startup_lense/modules/idea_improve/models/improve_suggestion_model.dart';


class IdeaImproveController extends GetxController {

  final _repo = ImproveRepository();

  // ─── Text Controllers ─────────────────────────────────────
  final titleController    = TextEditingController();
  final problemController  = TextEditingController();
  final marketController   = TextEditingController();
  final strategyController = TextEditingController();

  // ─── State ────────────────────────────────────────────────
  var isLoading         = true.obs;   // initial fetch + suggestions
  var isSaving          = false.obs;  // re-analysis on save
  var loadingMessage    = ''.obs;
  var scale             = 1.0.obs;

  // ─── Idea data (from Firestore) ───────────────────────────
  late String _ideaId;
  late String _city;
  late String _businessType;
  late double _budget;
  late List<String> _customers;
  late Map<String, dynamic> _fullDoc;

  // ─── Score ────────────────────────────────────────────────
  var score = 0.obs;

  // ─── Suggestions ──────────────────────────────────────────
  var titleSuggestion    = ImproveSuggestionModel.empty().obs;
  var problemSuggestion  = ImproveSuggestionModel.empty().obs;
  var marketSuggestion   = ImproveSuggestionModel.empty().obs;
  var strategySuggestion = ImproveSuggestionModel.empty().obs;

  // ─── Loading perception steps ─────────────────────────────
  static const _fetchSteps = [
    'Loading your idea...',
    'Reading AI evaluation data...',
    'Identifying weak areas...',
    'Generating title improvement...',
    'Generating problem clarity fix...',
    'Generating market refinement...',
    'Generating strategy upgrade...',
    'Finalizing suggestions...',
  ];

  static const _saveSteps = [
    'Applying your improvements...',
    'Running Structuring Agent...',
    'Running Market Agent...',
    'Running Risk Agent...',
    'Running Strategy Agent...',
    'Running Evaluation Agent...',
    'Calculating new score...',
    'Saving to cloud...',
  ];

  // ─── Lifecycle ────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      _ideaId = args['id'] as String? ?? '';
      _loadAndGenerateSuggestions();
    }
  }

  // ─── Step 1: Fetch + Generate Suggestions ─────────────────
  Future<void> _loadAndGenerateSuggestions() async {
    isLoading.value = true;

    try {
      // ── Fetch full doc ────────────────────────────────────
      _setMessage(_fetchSteps[0]);
      _fullDoc = await _repo.getFullIdea(_ideaId);

      _setMessage(_fetchSteps[1]);
      await Future.delayed(const Duration(milliseconds: 300));

      // ── Extract fields ────────────────────────────────────
      _city         = _fullDoc['city']         as String? ?? '';
      _businessType = _fullDoc['businessType'] as String? ?? '';
      _budget       = (_fullDoc['budget'] as num?)?.toDouble() ?? 0;
      _customers    = List<String>.from(_fullDoc['targetCustomers'] ?? []);

      final aiResult = Map<String, dynamic>.from(
          _fullDoc['aiResult'] as Map? ?? {});

      // ── Populate fields with current values ───────────────
      titleController.text    = _fullDoc['title']   as String? ?? '';
      problemController.text  = _fullDoc['problem'] as String? ?? '';
      marketController.text   =
          aiResult['structuring']?['customerSegment'] as String? ?? '';
      strategyController.text =
          aiResult['structuring']?['revenueModel']    as String? ?? '';

      score.value = (_fullDoc['score'] as num?)?.toInt() ?? 0;

      // ── Generate suggestions ──────────────────────────────
      _setMessage(_fetchSteps[2]);
      await Future.delayed(const Duration(milliseconds: 400));

      _setMessage(_fetchSteps[3]);
      final raw = await _repo.generateSuggestions(
        title:        titleController.text,
        problem:      problemController.text,
        city:         _city,
        businessType: _businessType,
        budget:       _budget,
        customers:    _customers,
        aiResult:     aiResult,
      );

      _setMessage(_fetchSteps[7]);
      await Future.delayed(const Duration(milliseconds: 300));

      // ── Map suggestions ───────────────────────────────────
      titleSuggestion.value    =
          ImproveSuggestionModel.fromMap(raw['title']    as Map<String, dynamic>? ?? {});
      problemSuggestion.value  =
          ImproveSuggestionModel.fromMap(raw['problem']  as Map<String, dynamic>? ?? {});
      marketSuggestion.value   =
          ImproveSuggestionModel.fromMap(raw['market']   as Map<String, dynamic>? ?? {});
      strategySuggestion.value =
          ImproveSuggestionModel.fromMap(raw['strategy'] as Map<String, dynamic>? ?? {});

    } catch (e) {
      _showErrorSnackbar('Failed to load improvements: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Apply Suggestions ────────────────────────────────────
  void applyTitleSuggestion() =>
      titleController.text = titleSuggestion.value.suggestion;

  void applyProblemSuggestion() =>
      problemController.text = problemSuggestion.value.suggestion;

  void applyMarketSuggestion() =>
      marketController.text = marketSuggestion.value.suggestion;

  void applyStrategySuggestion() =>
      strategyController.text = strategySuggestion.value.suggestion;

  // ─── Step 2: Save — Re-run full agent pipeline ────────────
  Future<void> saveImprovedIdea() async {
    isSaving.value = true;

    try {
      int _step = 0;

      await AgentRunner().run(
        ideaId:       _ideaId,
        title:        titleController.text.trim(),
        problem:      problemController.text.trim(),
        customers:    _customers,
        city:         _city,
        businessType: _businessType,
        budget:       _budget,
        onProgress: (agentName, isDone) {
          if (!isDone) {
            // Map agent name → perception message
            switch (agentName) {
              case 'structuring':
                _setMessage(_saveSteps[1]);
                break;
              case 'market':
                _setMessage(_saveSteps[2]);
                break;
              case 'risk':
                _setMessage(_saveSteps[3]);
                break;
              case 'strategy':
                _setMessage(_saveSteps[4]);
                break;
              case 'evaluation':
                _setMessage(_saveSteps[5]);
                break;
            }
          } else if (agentName == 'evaluation') {
            _setMessage(_saveSteps[6]);
          }
        },
      );

      _setMessage(_saveSteps[7]);
      await Future.delayed(const Duration(milliseconds: 500));

      Get.snackbar(
        'Improved!',
        'Your idea has been re-analyzed with the latest improvements.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF06B6D4).withOpacity(0.15),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      Get.back(result: {'updated': true});

    } catch (e) {
      _showErrorSnackbar('Failed to save improvements: $e');
    } finally {
      isSaving.value = false;
    }
  }

  // ─── Helpers ──────────────────────────────────────────────
  void _setMessage(String msg) => loadingMessage.value = msg;

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.15),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    problemController.dispose();
    marketController.dispose();
    strategyController.dispose();
    super.onClose();
  }
}