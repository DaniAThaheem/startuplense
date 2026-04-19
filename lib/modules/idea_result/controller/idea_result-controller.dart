import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ResultController extends GetxController {
  final idea = Get.arguments;

  var isLoading = true.obs;
  var title =  "".obs;

  final RxInt score = 22.obs;
  var visibleCards = 0.obs;

  var confidence = "High".obs;
  var agreement = "High".obs;

  var demand = "High".obs;
  var competition = "Medium".obs;
  var saturation = "Low".obs;

  var marketRisk = "Low".obs;
  var financialRisk = "Medium".obs;
  var technicalRisk = "Low".obs;

  var problemStrength = "Strong".obs;
  var valuePropStrength = "Medium".obs;
  var audienceClarity = "Clear".obs;

  var structureTags = <String>[].obs;


  var riskTags = <String>[].obs;

  var verdict = "Viable".obs;
  var verdictLine = "".obs;

  var marketInsight = "".obs;
  var marketTags = <String>[].obs;

  var riskInsight = "".obs;

  var marketSignals = <String>[].obs;

  var problem = "".obs;
  var valueProp = "".obs;

  var revenue = "".obs;

  var businessModel = "Subscription + Commission".obs;

  var marketingChannels = <String>[
    "University ambassadors",
    "Social campaigns",
  ].obs;

  var phaseOne = "Launch in 2 universities with pilot users".obs;
  var phaseTwo = "Expand via ambassador network".obs;

  var launchPhase = "".obs;

  var marketing = "".obs;
  var strategyTags = <String>[].obs;

  var finalVerdict = "".obs;
  var finalExplanation = "".obs;

  var improvements = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
    });

    final args = Get.arguments;

    if (args != null) {
      title.value = args["title"] ?? "";
      score.value = args["score"] ?? 0;
      verdictLine.value = args["verdict"] ?? "";
      marketInsight.value = args["market"] ?? "";
    }

    riskInsight.value = "Moderate financial and execution risk";
    problem.value = "Students lack centralized idea validation tools";
    valueProp.value = "Fast AI-driven idea scoring";

    revenue.value = "Subscription + Commission model";
    businessModel.value = "Freemium SaaS";

    launchPhase.value = "Phase 1 → University testing";

    marketing.value = "University ambassadors + social media";

    finalVerdict.value = "Viable";

    finalExplanation.value =
    "Strong validation signals but requires niche focus.";


    improvements.assignAll([
      "Improve differentiation",
      "Reduce competition overlap",
      "Focus on student niche",
    ]);

    marketSignals.assignAll([
      "Rising Trend",
      "Niche Gap",
    ]);

    riskTags.assignAll([
      "Low entry barrier",
      "Burn rate concern",
    ]);

    structureTags.assignAll([
      "Clear problem definition",
      "Target audience identified",
    ]);

    _startSequence();
  }




  void _startSequence() async {
    for (int i = 1; i <= 6; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      visibleCards.value = i;
    }
  }
}