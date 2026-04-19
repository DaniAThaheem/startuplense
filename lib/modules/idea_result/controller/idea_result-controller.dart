import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';


class ResultController extends GetxController {
  final idea = Get.arguments;

  var isSaved = false.obs;


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

  void toggleSave() {
    isSaved.value = !isSaved.value;
  }

  void compareIdea() {
    Get.snackbar("Compare", "Compare feature coming soon");
  }


  void _startSequence() async {
    for (int i = 1; i <= 6; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      visibleCards.value = i;
    }
  }



  Future<void> exportPremiumReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(28),
        build: (context) => [

          // 🔷 HEADER
          _header(),

          pw.SizedBox(height: 20),

          // 🔷 SCORE CARD
          _scoreCard(),

          pw.SizedBox(height: 20),

          // 🔷 MARKET
          _card(
            "Market Intelligence",
            [
              _tripleMetricRow(
                "Demand", demand.value,
                "Competition", competition.value,
                "Saturation", saturation.value,
              ),
              _insight(marketInsight.value),
              _tagLine("Signals", marketTags),
            ],
          ),

          pw.SizedBox(height: 16),

          // 🔷 RISK
          _card(
            "Risk Matrix",
            [
              _keyValue("Market Risk", marketRisk.value),
              _keyValue("Financial Risk", financialRisk.value),
              _keyValue("Technical Risk", technicalRisk.value),
              _insight(riskInsight.value),
              _tagLine("Risk Signals", riskTags),
            ],
          ),

          pw.SizedBox(height: 16),

          // 🔷 STRUCTURE
          _card(
            "Structure Validation",
            [
              _keyValue("Problem", problem.value),
              _keyValue("Value Proposition", valueProp.value),
              _keyValue("Revenue", revenue.value),
            ],
          ),

          pw.SizedBox(height: 16),

          // 🔷 STRATEGY
          _card(
            "Strategy Overview",
            [
              _sectionMini("Business Model", businessModel.value),
              _sectionMini("Marketing", marketing.value),
              _sectionMini("Launch Plan", launchPhase.value),
            ],
          ),

          pw.SizedBox(height: 20),

          // 🔴 FINAL DECISION
          _finalDecisionCard(),

        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  pw.Widget _header() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("Startup Lens",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            )),

        pw.SizedBox(height: 4),

        pw.Text("AI Evaluation Report",
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            )),

        pw.SizedBox(height: 6),

        pw.Text(
          DateTime.now().toString().split(" ")[0],
          style: const pw.TextStyle(fontSize: 10),
        ),

        pw.Divider(),
      ],
    );
  }

  pw.Widget _scoreCard() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [

          pw.Text("Viability Score",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

          pw.SizedBox(height: 8),

          pw.Text("${score.value}/100",
              style: pw.TextStyle(
                  fontSize: 36,
                  fontWeight: pw.FontWeight.bold)),

          pw.SizedBox(height: 6),

          pw.Row(
            children: [
              _badge("Confidence: ${confidence.value}"),
              pw.SizedBox(width: 8),
              _badge("Agreement: ${agreement.value}"),
            ],
          ),

          pw.SizedBox(height: 10),

          pw.Text(
            verdictLine.value,
            style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
          ),
        ],
      ),
    );
  }

  pw.Widget _card(String title, List<pw.Widget> children) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title,
              style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          ...children,
        ],
      ),
    );
  }

  pw.Widget _tripleMetricRow(
      String k1, String v1,
      String k2, String v2,
      String k3, String v3) {

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _metric(k1, v1),
        _metric(k2, v2),
        _metric(k3, v3),
      ],
    );
  }

  pw.Widget _metric(String key, String value) {
    return pw.Column(
      children: [
        pw.Text(key, style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 4),
        pw.Text(value,
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold)),
      ],
    );
  }


  pw.Widget _insight(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 6),
      child: pw.Text(text),
    );
  }

  pw.Widget _tagLine(String title, List<String> tags) {
    if (tags.isEmpty) return pw.SizedBox();

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 6),
      child: pw.Text("$title: ${tags.join(", ")}"),
    );
  }

  pw.Widget _keyValue(String key, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(key),
          pw.Text(value,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  pw.Widget _sectionMini(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      ),
    );
  }


  pw.Widget _finalDecisionCard() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [

          pw.Text("Final AI Decision",
              style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold)),

          pw.SizedBox(height: 8),

          pw.Text(finalVerdict.value,
              style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold)),

          pw.SizedBox(height: 6),

          pw.Text(finalExplanation.value),

          pw.SizedBox(height: 10),

          pw.Text("Improvements",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

          pw.SizedBox(height: 6),

          ...improvements.map((e) => pw.Bullet(text: e)),

        ],
      ),
    );
  }

  pw.Widget _badge(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }
}