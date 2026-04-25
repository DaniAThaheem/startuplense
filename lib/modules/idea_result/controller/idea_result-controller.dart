import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class ResultController extends GetxController {
  final idea = Get.arguments;

  var isSaved      = false.obs;
  var isLoading    = true.obs;
  var visibleCards = 0.obs;
  var title        = ''.obs;

  // ─── Score ────────────────────────────────────────────────
  final RxInt score = 0.obs;
  var confidence    = 'Medium'.obs;
  var agreement     = 'Medium'.obs;
  var verdictLine   = ''.obs;
  var verdict       = ''.obs;

  // ─── Market ───────────────────────────────────────────────
  var demand        = 'Medium'.obs;
  var competition   = 'Medium'.obs;
  var saturation    = 'Medium'.obs;
  var marketInsight = ''.obs;
  var marketTags    = <String>[].obs;
  var marketSignals = <String>[].obs;
  var tam           = ''.obs;
  var marketSentiment = ''.obs;

  // ─── Risk ─────────────────────────────────────────────────
  var marketRisk    = 'Medium'.obs;
  var financialRisk = 'Medium'.obs;
  var technicalRisk = 'Medium'.obs;
  var riskInsight   = ''.obs;
  var riskTags      = <String>[].obs;

  // ─── Structure ────────────────────────────────────────────
  var problem             = ''.obs;
  var valueProp           = ''.obs;
  var revenue             = ''.obs;
  var problemStrength     = 'Medium'.obs;
  var valuePropStrength   = 'Medium'.obs;
  var audienceClarity     = 'Moderate'.obs;
  var structureTags       = <String>[].obs;
  var businessModelType   = ''.obs;
  var customerSegment     = ''.obs;

  // ─── Strategy ─────────────────────────────────────────────
  var businessModel      = ''.obs;
  var pricingStrategy    = ''.obs;
  var marketingChannels  = <String>[].obs;
  var revenueStreams      = <String>[].obs;
  var strategyTags       = <String>[].obs;
  var launchPhases       = <Map<String, dynamic>>[].obs;
  var capex              = 0.0.obs;
  var burnRate           = ''.obs;
  var roiHorizon         = ''.obs;
  var marketing          = ''.obs;
  var launchPhase        = ''.obs;

  // ─── Final ────────────────────────────────────────────────
  var finalVerdict     = ''.obs;
  var finalExplanation = ''.obs;
  var improvements     = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });

    final args = Get.arguments as Map<String, dynamic>? ?? {};

    // ── Core ──────────────────────────────────────────────────
    title.value       = args['title']       ?? '';
    score.value       = (args['score'] as num?)?.toInt() ?? 0;
    verdictLine.value = args['verdictLine'] ?? args['verdict'] ?? '';
    verdict.value     = args['verdict']     ?? '';
    confidence.value  = args['confidence']  ?? 'Medium';
    agreement.value   = args['agreement']   ?? 'Medium';

    // ── Market ────────────────────────────────────────────────
    demand.value          = args['demand']          ?? 'Medium';
    competition.value     = args['competition']     ?? 'Medium';
    saturation.value      = args['saturation']      ?? 'Medium';
    marketInsight.value   = args['market']          ?? '';
    tam.value             = args['tam']             ?? '';
    marketSentiment.value = args['marketSentiment'] ?? '';

    final ms = args['marketSignals'];
    if (ms is List) marketSignals.assignAll(List<String>.from(ms));
    final mt = args['marketTags'];
    if (mt is List) marketTags.assignAll(List<String>.from(mt));

    // ── Risk ──────────────────────────────────────────────────
    marketRisk.value    = args['marketRisk']    ?? 'Medium';
    financialRisk.value = args['financialRisk'] ?? 'Medium';
    technicalRisk.value = args['technicalRisk'] ?? 'Medium';
    riskInsight.value   = args['riskInsight']   ?? '';

    final rt = args['riskTags'];
    if (rt is List) riskTags.assignAll(List<String>.from(rt));

    // ── Structure ─────────────────────────────────────────────
    problem.value           = args['problemStatement']  ?? '';
    valueProp.value         = args['valuePropFull']     ?? '';
    revenue.value           = args['revenueModel']      ?? '';
    businessModelType.value = args['businessModelType'] ?? '';
    customerSegment.value   = args['customerSegment']   ?? '';
    problemStrength.value   = args['problemStrength']   ?? 'Medium';
    valuePropStrength.value = args['valuePropStrength'] ?? 'Medium';
    audienceClarity.value   = args['audienceClarity']   ?? 'Moderate';

    final kr = args['keyResources'];
    if (kr is List) structureTags.assignAll(List<String>.from(kr));

    // ── Strategy ──────────────────────────────────────────────
    businessModel.value   = args['businessModel']   ?? args['businessModelType'] ?? '';
    pricingStrategy.value = args['pricingStrategy'] ?? '';
    burnRate.value        = args['burnRate']         ?? '';
    roiHorizon.value      = args['roiHorizon']       ?? '';
    capex.value           = (args['capex'] as num?)?.toDouble() ?? 0;

    final mc = args['marketingChannels'];
    if (mc is List) {
      marketingChannels.assignAll(List<String>.from(mc));
      marketing.value = marketingChannels.join(', ');
    }

    final rs = args['revenueStreams'];
    if (rs is List) revenueStreams.assignAll(List<String>.from(rs));

    final st = args['strategyTags'];
    if (st is List) strategyTags.assignAll(List<String>.from(st));

    final phases = args['launchPhases'];
    if (phases is List) {
      launchPhases.assignAll(
        phases.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
      );
      if (launchPhases.isNotEmpty) {
        launchPhase.value = launchPhases[0]['title'] ?? '';
      }
    }

    // ── Final ─────────────────────────────────────────────────
    finalVerdict.value     = args['finalVerdict']     ?? args['verdict'] ?? '';
    finalExplanation.value = args['finalExplanation'] ?? '';

    final impr = args['improvements'];
    if (impr is List) improvements.assignAll(List<String>.from(impr));

    _startSequence();
  }

  void toggleSave() => isSaved.value = !isSaved.value;

  void compareIdea() => Get.toNamed('/compare');

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
          _header(), pw.SizedBox(height: 20),
          _scoreCard(), pw.SizedBox(height: 20),
          _card("Market Intelligence", [
            _tripleMetricRow("Demand", demand.value, "Competition",
                competition.value, "Saturation", saturation.value),
            _insight(marketInsight.value),
            _tagLine("Signals", marketTags),
          ]),
          pw.SizedBox(height: 16),
          _card("Risk Matrix", [
            _keyValue("Market Risk", marketRisk.value),
            _keyValue("Financial Risk", financialRisk.value),
            _keyValue("Technical Risk", technicalRisk.value),
            _insight(riskInsight.value),
            _tagLine("Risk Signals", riskTags),
          ]),
          pw.SizedBox(height: 16),
          _card("Structure Validation", [
            _keyValue("Problem", problem.value),
            _keyValue("Value Proposition", valueProp.value),
            _keyValue("Revenue", revenue.value),
          ]),
          pw.SizedBox(height: 16),
          _card("Strategy Overview", [
            _sectionMini("Business Model", businessModel.value),
            _sectionMini("Pricing", pricingStrategy.value),
            _sectionMini("Marketing", marketing.value),
            _sectionMini("Launch Plan", launchPhase.value),
          ]),
          pw.SizedBox(height: 20),
          _finalDecisionCard(),
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // ── PDF helpers (unchanged) ───────────────────────────────
  pw.Widget _header() => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text("Startup Lens", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 4),
      pw.Text("AI Evaluation Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 6),
      pw.Text(DateTime.now().toString().split(" ")[0], style: const pw.TextStyle(fontSize: 10)),
      pw.Divider(),
    ],
  );

  pw.Widget _scoreCard() => pw.Container(
    padding: const pw.EdgeInsets.all(16),
    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300), borderRadius: pw.BorderRadius.circular(10)),
    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text("Viability Score", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 8),
      pw.Text("${score.value}/100", style: pw.TextStyle(fontSize: 36, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 6),
      pw.Row(children: [_badge("Confidence: ${confidence.value}"), pw.SizedBox(width: 8), _badge("Agreement: ${agreement.value}")]),
      pw.SizedBox(height: 10),
      pw.Text(verdictLine.value, style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
    ]),
  );

  pw.Widget _card(String title, List<pw.Widget> children) => pw.Container(
    padding: const pw.EdgeInsets.all(14),
    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300), borderRadius: pw.BorderRadius.circular(10)),
    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
      pw.Divider(), ...children,
    ]),
  );

  pw.Widget _tripleMetricRow(String k1, String v1, String k2, String v2, String k3, String v3) =>
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [_metric(k1, v1), _metric(k2, v2), _metric(k3, v3)]);

  pw.Widget _metric(String key, String value) => pw.Column(children: [
    pw.Text(key, style: const pw.TextStyle(fontSize: 10)),
    pw.SizedBox(height: 4),
    pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  ]);

  pw.Widget _insight(String text) => pw.Padding(padding: const pw.EdgeInsets.only(top: 6), child: pw.Text(text));

  pw.Widget _tagLine(String title, List<String> tags) {
    if (tags.isEmpty) return pw.SizedBox();
    return pw.Padding(padding: const pw.EdgeInsets.only(top: 6), child: pw.Text("$title: ${tags.join(", ")}"));
  }

  pw.Widget _keyValue(String key, String value) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text(key), pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))]),
  );

  pw.Widget _sectionMini(String title, String value) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 6),
    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.Text(value),
    ]),
  );

  pw.Widget _finalDecisionCard() => pw.Container(
    padding: const pw.EdgeInsets.all(16),
    decoration: pw.BoxDecoration(color: PdfColors.grey200, borderRadius: pw.BorderRadius.circular(10)),
    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text("Final AI Decision", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 8),
      pw.Text(finalVerdict.value, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 6),
      pw.Text(finalExplanation.value),
      pw.SizedBox(height: 10),
      pw.Text("Improvements", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 6),
      ...improvements.map((e) => pw.Bullet(text: e)),
    ]),
  );

  pw.Widget _badge(String text) => pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400), borderRadius: pw.BorderRadius.circular(6)),
    child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
  );
}