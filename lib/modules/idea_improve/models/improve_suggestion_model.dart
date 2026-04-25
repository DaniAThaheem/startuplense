class ImproveSuggestionModel {
  final String suggestion;
  final String reason;

  ImproveSuggestionModel({
    required this.suggestion,
    required this.reason,
  });

  factory ImproveSuggestionModel.fromMap(Map<String, dynamic> map) {
    return ImproveSuggestionModel(
      suggestion: map['suggestion'] as String? ?? '',
      reason:     map['reason']     as String? ?? '',
    );
  }

  static ImproveSuggestionModel empty() =>
      ImproveSuggestionModel(suggestion: '', reason: '');
}