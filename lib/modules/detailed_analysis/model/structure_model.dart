class CoreAlignmentModel {
  final double matchScore; // 0.0 → 1.0
  final String description;

  CoreAlignmentModel({
    required this.matchScore,
    required this.description,
  });

  String get matchText => "${(matchScore * 100).toInt()}% match";

  bool get isStrong => matchScore >= 0.75;
}
