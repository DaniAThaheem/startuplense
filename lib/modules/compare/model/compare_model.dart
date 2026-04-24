class CompareResultModel {
  final String viabilityInsight;
  final String riskA;
  final String riskB;
  final List<String> riskFactorsA;
  final List<String> riskFactorsB;
  final String riskInsight;
  final double marketDemand;
  final double marketCompetition;
  final double marketOpportunity;
  final String marketInsight;
  final String winner;
  final String winnerTitle;
  final String recommendation;
  final String strengthA;
  final String strengthB;

  CompareResultModel({
    required this.viabilityInsight,
    required this.riskA,
    required this.riskB,
    required this.riskFactorsA,
    required this.riskFactorsB,
    required this.riskInsight,
    required this.marketDemand,
    required this.marketCompetition,
    required this.marketOpportunity,
    required this.marketInsight,
    required this.winner,
    required this.winnerTitle,
    required this.recommendation,
    required this.strengthA,
    required this.strengthB,
  });

  factory CompareResultModel.fromMap(Map<String, dynamic> map) {
    return CompareResultModel(
      viabilityInsight:  map['viabilityInsight']  as String? ?? '',
      riskA:             map['riskA']             as String? ?? 'Medium',
      riskB:             map['riskB']             as String? ?? 'Medium',
      riskFactorsA:      _toList(map['riskFactorsA']),
      riskFactorsB:      _toList(map['riskFactorsB']),
      riskInsight:       map['riskInsight']       as String? ?? '',
      marketDemand:      (map['marketDemand']     as num?)?.toDouble() ?? 0,
      marketCompetition: (map['marketCompetition'] as num?)?.toDouble() ?? 0,
      marketOpportunity: (map['marketOpportunity'] as num?)?.toDouble() ?? 0,
      marketInsight:     map['marketInsight']     as String? ?? '',
      winner:            map['winner']            as String? ?? 'A',
      winnerTitle:       map['winnerTitle']       as String? ?? '',
      recommendation:    map['recommendation']    as String? ?? '',
      strengthA:         map['strengthA']         as String? ?? '',
      strengthB:         map['strengthB']         as String? ?? '',
    );
  }

  static List<String> _toList(dynamic v) {
    if (v is List) return List<String>.from(v);
    return [];
  }
}