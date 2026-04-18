import 'dart:async';
import 'package:get/get.dart';
import 'package:startup_lense/routes/app_routes.dart';

class ProcessingController extends GetxController {
  // Progress 0 → 100
  var progress = 0.0.obs;

  // Steps status
  var steps = [
    {"title": "Structuring Idea", "status": "done"},
    {"title": "Market Analysis", "status": "processing"},
    {"title": "Risk Assessment", "status": "waiting"},
    {"title": "Strategy Generation", "status": "waiting"},
  ].obs;

  // Dynamic status text
  var statusText = "Analyzing market conditions...".obs;

  final List<String> messages = [
    "Analyzing market conditions...",
    "Evaluating competition landscape...",
    "Estimating risk factors...",
    "Generating strategy insights...",
    "Almost done...",
  ];

  Timer? _progressTimer;
  Timer? _textTimer;

  late String ideaTitle;


  void _startProcessing() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (progress.value >= 100) {
        timer.cancel();
        _completeFlow();
        return;
      }

      progress.value += 0.5;

      _updateSteps();
    });
  }

  void _updateSteps() {
    if (progress.value > 25) {
      steps[1]["status"] = "done";
      steps[2]["status"] = "processing";
    }
    if (progress.value > 50) {
      steps[2]["status"] = "done";
      steps[3]["status"] = "processing";
    }
    if (progress.value > 75) {
      steps[3]["status"] = "done";
    }
    steps.refresh();
  }

  void _rotateMessages() {
    int index = 0;
    _textTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      statusText.value = messages[index % messages.length];
      index++;
    });
  }

  void cancelProcessing() {
    _progressTimer?.cancel();
    _textTimer?.cancel();
    Get.back();
    Get.snackbar("Cancelled", "Analysis cancelled");
  }

  void _completeFlow() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final result = {
      "title": ideaTitle,
      "score": 85,
      "status": "Analyzed",
    };

    goToResult();
  }


  void goToResult() async {
    await Future.delayed(const Duration(seconds: 2));

    Get.offNamed(
      AppRoutes.RESULT,
      arguments: {
        "title": "AI Food Delivery for Students",
        "score": 78,
        "verdict": "Viable with moderate competition",
        "market": "High demand detected",
      },
    );
  }



  @override
  void onInit() {
    super.onInit();

    ideaTitle = Get.arguments?["title"] ?? "Untitled Idea";

    _startProcessing();
    _rotateMessages();
  }


  @override
  void onClose() {
    _progressTimer?.cancel();
    _textTimer?.cancel();
    super.onClose();
  }
}
