import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:startup_lense/data/repositories/compare_repository.dart';
import 'package:startup_lense/modules/compare/model/compare_model.dart';
import 'package:startup_lense/modules/idea_history/controller/Idea_history_controller.dart';

class CompareController extends GetxController {
  final _repo = CompareRepository();

  // ─── Selected Ideas ───────────────────────────────────────
  var ideaA = Rxn<IdeaModel>();
  var ideaB = Rxn<IdeaModel>();

  // ─── State ────────────────────────────────────────────────
  var isComparing    = false.obs;
  var isLoading      = false.obs;
  var loadingMessage = ''.obs;
  var result         = Rxn<CompareResultModel>();

  // ─── Derived scores (from IdeaModel for display) ──────────
  var scoreA = 0.0.obs;
  var scoreB = 0.0.obs;

  // ─── Loading messages for AI perception ───────────────────
  static const _loadingSteps = [
    'Initializing AI analysis engine...',
    'Extracting market signals from Idea A...',
    'Extracting market signals from Idea B...',
    'Running risk matrix comparison...',
    'Evaluating viability scores...',
    'Analyzing competitive landscape...',
    'Synthesizing AI recommendation...',
    'Finalizing comparison report...',
  ];

  // ─── Selection ────────────────────────────────────────────
  void selectIdeaA(IdeaModel idea) {
    ideaA.value = idea;
    scoreA.value = idea.score.toDouble();
    _checkAndCompare();
  }

  void selectIdeaB(IdeaModel idea) {
    ideaB.value = idea;
    scoreB.value = idea.score.toDouble();
    _checkAndCompare();
  }

  void _checkAndCompare() {
    if (ideaA.value != null && ideaB.value != null) {
      _runComparison();
    }
  }

  // ─── Core Comparison Flow ─────────────────────────────────
  Future<void> _runComparison() async {
    isLoading.value   = true;
    isComparing.value = false;
    result.value      = null;

    try {
      // ── Step 1: fetch full Firestore docs ──────────────────
      _setMessage(0);
      final fullA = await _repo.getFullIdea(ideaA.value!.id);

      _setMessage(1);
      final fullB = await _repo.getFullIdea(ideaB.value!.id);

      // ── Step 2: cycle through AI perception messages ───────
      _setMessage(2);
      await Future.delayed(const Duration(milliseconds: 600));

      _setMessage(3);
      await Future.delayed(const Duration(milliseconds: 500));

      _setMessage(4);

      // ── Step 3: call AI ────────────────────────────────────
      final raw = await _repo.compareIdeas(ideaA: fullA, ideaB: fullB);

      _setMessage(5);
      await Future.delayed(const Duration(milliseconds: 400));

      _setMessage(6);
      await Future.delayed(const Duration(milliseconds: 400));

      _setMessage(7);
      await Future.delayed(const Duration(milliseconds: 300));

      // ── Step 4: map result ─────────────────────────────────
      result.value = CompareResultModel.fromMap(raw);
      isComparing.value = true;

    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _setMessage(int index) {
    loadingMessage.value = _loadingSteps[index % _loadingSteps.length];
  }

  // ─── Reset ────────────────────────────────────────────────
  void reset() {
    ideaA.value       = null;
    ideaB.value       = null;
    isComparing.value = false;
    isLoading.value   = false;
    result.value      = null;
    scoreA.value      = 0;
    scoreB.value      = 0;
    loadingMessage.value = '';
  }

  // ─── Snackbars ────────────────────────────────────────────
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Comparison Failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.15),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
}