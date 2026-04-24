import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:startup_lense/data/agents/agent_runner.dart';
import 'package:startup_lense/routes/app_routes.dart';

class ProcessingController extends GetxController {

  // ── UI State ──────────────────────────────────────────────────────
  var progress = 0.0.obs;
  var statusText = "Initializing AI agents...".obs;
  var steps = <Map<String, String>>[
    {"title": "Idea Structuring",    "status": "waiting"},
    {"title": "Market Analysis",     "status": "waiting"},
    {"title": "Risk Assessment",     "status": "waiting"},
    {"title": "Strategy Generation", "status": "waiting"},
    {"title": "Final Evaluation",    "status": "waiting"},
  ].obs;

  // ── Agent metadata ────────────────────────────────────────────────
  static const _agentOrder = [
    'structuring', 'market', 'risk', 'strategy', 'evaluation',
  ];
  static const _agentMessages = {
    'structuring': 'Structuring your business model...',
    'market':      'Analyzing market landscape...',
    'risk':        'Evaluating risks and opportunities...',
    'strategy':    'Generating go-to-market strategy...',
    'evaluation':  'Calculating viability score...',
  };
  static const _agentProgressDone = {
    'structuring': 20.0,
    'market':      40.0,
    'risk':        60.0,
    'strategy':    80.0,
    'evaluation':  100.0,
  };

  // ── Private ───────────────────────────────────────────────────────
  late String _ideaId;
  late String _ideaTitle;
  late Map<String, dynamic> _ideaData;
  bool _navigated = false;

  final _runner = AgentRunner();

  // ── Lifecycle ─────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _ideaId    = Get.arguments?['ideaId'] ?? '';
    _ideaTitle = Get.arguments?['title']  ?? 'Untitled Idea';
    _runPipeline();
  }

  // ── Pipeline ──────────────────────────────────────────────────────
  Future<void> _runPipeline() async {
    // Read the idea data submitted to Firestore
    try {
      final snap = await FirebaseFirestore.instance
          .collection('ideas')
          .doc(_ideaId)
          .get();
      _ideaData = snap.data()!;
    } catch (e) {
      Get.snackbar('Error', 'Could not load idea: $e');
      Get.back();
      return;
    }

    try {
      final result = await _runner.run(
        ideaId:       _ideaId,
        title:        _ideaData['title']        ?? _ideaTitle,
        problem:      _ideaData['problem']       ?? '',
        customers:    List<String>.from(_ideaData['targetCustomers'] ?? []),
        city:         _ideaData['city']          ?? '',
        businessType: _ideaData['businessType']  ?? '',
        budget:       (_ideaData['budget'] as num?)?.toDouble() ?? 0.0,
        onProgress: _onAgentProgress,
      );

      if (!_navigated) {
        _navigated = true;
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offNamed(
          AppRoutes.RESULT,
          arguments: result.toArguments(
            ideaId: _ideaId,
            title:  _ideaTitle,
          ),
        );
      }
    } catch (e) {
      // Mark failed in Firestore
      await FirebaseFirestore.instance
          .collection('ideas')
          .doc(_ideaId)
          .update({'status': 'failed', 'errorMessage': e.toString()});

      Get.snackbar('Analysis Failed', e.toString());
      Get.back();
    }
  }

  // ── Progress callback from AgentRunner ────────────────────────────
  void _onAgentProgress(String agentName, bool isDone) {
    final idx = _agentOrder.indexOf(agentName);
    if (idx == -1) return;

    if (!isDone) {
      // Agent just started
      statusText.value = _agentMessages[agentName] ?? '';
      steps[idx] = {"title": steps[idx]["title"]!, "status": "processing"};
    } else {
      // Agent completed
      steps[idx] = {"title": steps[idx]["title"]!, "status": "done"};
      progress.value = _agentProgressDone[agentName]!;
    }
    steps.refresh();
  }

  // ── Cancel ────────────────────────────────────────────────────────
  void cancelProcessing() {
    _navigated = true; // prevent navigation after cancel
    FirebaseFirestore.instance
        .collection('ideas')
        .doc(_ideaId)
        .update({'status': 'cancelled'});
    Get.back();
    Get.snackbar('Cancelled', 'Analysis cancelled');
  }
}