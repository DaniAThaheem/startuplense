import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'structuring_agent.dart';
import 'market_agent.dart';
import 'risk_agent.dart';
import 'strategy_agent.dart';
import 'evaluation_agent.dart';

/// Holds the complete output of all 5 agents.
class AgentResult {
  final Map<String, dynamic> structuring;
  final Map<String, dynamic> market;
  final Map<String, dynamic> risk;
  final Map<String, dynamic> strategy;
  final Map<String, dynamic> evaluation;

  const AgentResult({
    required this.structuring,
    required this.market,
    required this.risk,
    required this.strategy,
    required this.evaluation,
  });

  /// Flat map passed as Get.arguments to ResultController
  Map<String, dynamic> toArguments({
    required String ideaId,
    required String title,
  }) {
    return {
      'ideaId':   ideaId,
      'title':    title,

      // Top-level result fields
      'score':       (evaluation['score'] as num?)?.toInt() ?? 0,
      'verdict':     evaluation['verdict']     ?? '',
      'verdictLine': evaluation['verdictLine'] ?? '',
      'market':      market['marketInsight']   ?? '',
      'competition': market['competitionLevel'] ?? '',

      // Evaluation
      'confidence':             evaluation['confidence']             ?? 'Medium',
      'agreement':              evaluation['agreement']              ?? 'Medium',
      'metricScore':            (evaluation['metricScore'] as num?)?.toDouble() ?? 7.0,
      'coreAlignmentScore':     (evaluation['coreAlignmentScore'] as num?)?.toDouble() ?? 0.8,
      'coreAlignmentDesc':      evaluation['coreAlignmentDescription'] ?? '',
      'improvements':           List<String>.from(evaluation['improvements'] ?? []),
      'finalVerdict':           evaluation['verdict']                ?? '',
      'finalExplanation':       evaluation['feasibilityExplanation'] ?? '',

      // Market
      'demand':           market['demandLevel']      ?? 'Medium',
      'saturation':       market['saturationLevel']  ?? 'Medium',
      'competitors':      List<String>.from(market['competitors']   ?? []),
      'marketSignals':    List<String>.from(market['marketSignals'] ?? []),
      'marketTags':       List<String>.from(market['marketTags']    ?? []),
      'tam':              market['tam']               ?? '',
      'marketSentiment':  market['marketSentiment']   ?? '',

      // Risk
      'marketRisk':    risk['marketRisk']    ?? 'Medium',
      'financialRisk': risk['financialRisk'] ?? 'Medium',
      'technicalRisk': risk['technicalRisk'] ?? 'Medium',
      'riskInsight':   risk['riskInsight']   ?? '',
      'riskTags':      List<String>.from(risk['riskTags'] ?? []),
      'swot':          risk['swot']          ?? {},

      // Structure
      'problemStatement':  structuring['problemStatement']  ?? '',
      'customerSegment':   structuring['customerSegment']   ?? '',
      'valuePropFull':     structuring['valuePropFull']     ?? '',
      'revenueModel':      structuring['revenueModel']      ?? '',
      'keyResources':      List<String>.from(structuring['keyResources'] ?? []),
      'problemStrength':   structuring['problemStrength']   ?? 'Medium',
      'valuePropStrength': structuring['valuePropStrength'] ?? 'Medium',
      'audienceClarity':   structuring['audienceClarity']   ?? 'Moderate',
      'businessModelType': structuring['businessModelType'] ?? '',

      // Strategy
      'businessModel':     strategy['businessModel']    ?? '',
      'pricingStrategy':   strategy['pricingStrategy']  ?? '',
      'marketingChannels': List<String>.from(strategy['marketingChannels'] ?? []),
      'launchPhases':      List<Map<String, dynamic>>.from(
          (strategy['launchPhases'] as List? ?? [])
              .map((e) => Map<String, dynamic>.from(e as Map))
      ),
      'capex':             (strategy['capex'] as num?)?.toDouble() ?? 0.0,
      'burnRate':          strategy['burnRate']   ?? '',
      'roiHorizon':        strategy['roiHorizon'] ?? '',
      'revenueStreams':     List<String>.from(strategy['revenueStreams'] ?? []),
    };
  }
}

/// Callback signature: agent name + completion flag
typedef AgentProgressCallback = void Function(
    String agentName,
    bool isDone,
    );

class AgentRunner {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  /// Runs all 5 agents sequentially.
  /// Calls [onProgress] after each step with the agent name.
  /// Writes final aiResult + status to Firestore when complete.
  Future<AgentResult> run({
    required String ideaId,
    required String title,
    required String problem,
    required List<String> customers,
    required String city,
    required String businessType,
    required double budget,
    required AgentProgressCallback onProgress,
  }) async {
    // ── Agent 1: Structuring ────────────────────────────────────────
    onProgress('structuring', false);
    final structuring = await StructuringAgent.run(
      title: title,
      problem: problem,
      customers: customers,
      city: city,
      businessType: businessType,
      budget: budget,
    );
    onProgress('structuring', true);

    // ── Agent 2: Market ─────────────────────────────────────────────
    onProgress('market', false);
    final market = await MarketAgent.run(
      title: title,
      problem: problem,
      city: city,
      businessType: businessType,
      structureResult: structuring,
    );
    onProgress('market', true);

    // ── Agent 3: Risk ───────────────────────────────────────────────
    onProgress('risk', false);
    final risk = await RiskAgent.run(
      title: title,
      budget: budget,
      structureResult: structuring,
      marketResult: market,
    );
    onProgress('risk', true);

    // ── Agent 4: Strategy ───────────────────────────────────────────
    onProgress('strategy', false);
    final strategy = await StrategyAgent.run(
      title: title,
      city: city,
      budget: budget,
      structureResult: structuring,
      marketResult: market,
      riskResult: risk,
    );
    onProgress('strategy', true);

    // ── Agent 5: Evaluation ─────────────────────────────────────────
    onProgress('evaluation', false);
    final evaluation = await EvaluationAgent.run(
      title: title,
      structureResult: structuring,
      marketResult: market,
      riskResult: risk,
      strategyResult: strategy,
    );
    onProgress('evaluation', true);

    final result = AgentResult(
      structuring: structuring,
      market: market,
      risk: risk,
      strategy: strategy,
      evaluation: evaluation,
    );

    // ── Write complete result to Firestore ──────────────────────────
    await _firestore.collection('ideas').doc(ideaId).update({
      'status': 'done',
      'score':       evaluation['score'],
      'verdict':     evaluation['verdict'],
      'verdictLine': evaluation['verdictLine'],
      'aiResult': {
        'structuring': structuring,
        'market':      market,
        'risk':        risk,
        'strategy':    strategy,
        'evaluation':  evaluation,
      },
      'timestamps.updatedAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('users').doc(userId).set({
      'stats': {
        'ideasAnalyzed': FieldValue.increment(1),
      }
    }, SetOptions(merge: true));

    return result;
  }
}