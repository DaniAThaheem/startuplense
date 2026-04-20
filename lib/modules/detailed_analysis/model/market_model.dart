class MarketModel {
  final String title;
  final String description;
  final String sentiment;
  final String tam;

  final double demand;
  final double competition;
  final double scalability;

  MarketModel({
    required this.title,
    required this.description,
    required this.sentiment,
    required this.tam,
    required this.demand,
    required this.competition,
    required this.scalability,
  });
}