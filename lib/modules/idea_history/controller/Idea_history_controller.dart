import 'package:get/get.dart';

class IdeaModel {
  final String title;
  final String category;
  final int score;
  final String status;
  final String date;
  final String tag;

  IdeaModel({
    required this.title,
    required this.category,
    required this.score,
    required this.status,
    required this.date,
    required this.tag,
  });
}

class IdeaHistoryController extends GetxController {
  var ideas = <IdeaModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    ideas.assignAll([
      IdeaModel(
        title: "Eco-Friendly Logistics",
        category: "SUSTAINABILITY",
        score: 88,
        status: "Analyzed",
        date: "OCT 24, 2023",
        tag: "High Potential",
      ),
      IdeaModel(
        title: "Micro-SaaS Escrow",
        category: "FINTECH",
        score: 62,
        status: "Processing",
        date: "OCT 22, 2023",
        tag: "",
      ),
      IdeaModel(
        title: "Biometric Sleep Tuning",
        category: "HEALTH TECH",
        score: 92,
        status: "Analyzed",
        date: "OCT 20, 2023",
        tag: "Moonshot",
      ),
      IdeaModel(
        title: "Civic DAOs",
        category: "WEB3",
        score: 45,
        status: "Analyzed",
        date: "OCT 18, 2023",
        tag: "Low Feasibility",
      ),
    ]);
  }

  int get totalIdeas => ideas.length;

  double get avgScore =>
      ideas.isEmpty ? 0 : ideas.map((e) => e.score).reduce((a, b) => a + b) / ideas.length;

  int get bestScore =>
      ideas.isEmpty ? 0 : ideas.map((e) => e.score).reduce((a, b) => a > b ? a : b);
}