import 'package:get/get.dart';
import 'package:startup_lense/modules/main/controller/main_controller.dart';


enum SortType { highest, lowest, recent }
enum IdeaStatus { analyzed, processing }
enum ScoreRange { low, mid, high }



class IdeaModel {
  final String title;
  final String description;
  final String category;
  final int score;
  final String status;
  final String date;
  final String tag;

  IdeaModel({
    required this.title,
    required this.description,
    required this.category,
    required this.score,
    required this.status,
    required this.date,
    required this.tag,
  });
}

class IdeaHistoryController extends GetxController {
  var allIdeas = <IdeaModel>[].obs;
  var filteredIdeas = <IdeaModel>[].obs;
  var ideas = <IdeaModel>[].obs;

  var isSearching = false.obs;
  var searchQuery = ''.obs;

  final selectedSort = SortType.highest.obs;
  final selectedStatus = <IdeaStatus>{}.obs;
  final selectedScoreRange = ScoreRange.high.obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();

    // 🔥 ensure sync AFTER data loads
    ever(ideas, (_) {
      filteredIdeas.assignAll(ideas);
    });
  }

  void loadDummyData() {
    final data = [
      IdeaModel(
        title: "Eco-Friendly Logistics",
        description: "AI-optimized routing for electric fleets to reduce carbon emissions.",
        category: "SUSTAINABILITY",
        score: 88,
        status: "Analyzed",
        date: "OCT 24, 2023",
        tag: "High Potential",
      ),
      IdeaModel(
        title: "Micro-SaaS Escrow",
        description: "AI-optimized routing for electric fleets to reduce carbon emissions.",
        category: "FINTECH",
        score: 62,
        status: "Processing",
        date: "OCT 22, 2023",
        tag: "",
      ),
      IdeaModel(
        title: "Biometric Sleep Tuning",
        description: "AI-optimized routing for electric fleets to reduce carbon emissions.",
        category: "HEALTH TECH",
        score: 92,
        status: "Analyzed",
        date: "OCT 20, 2023",
        tag: "Moonshot",
      ),
      IdeaModel(
        title: "Civic DAOs",
        description: "AI-optimized routing for electric fleets to reduce carbon emissions.",
        category: "WEB3",
        score: 45,
        status: "Analyzed",
        date: "OCT 18, 2023",
        tag: "Low Feasibility",
      ),
    ];
    allIdeas.assignAll(data);  // store original
    ideas.assignAll(data);     // show on UI

  }
  void searchIdeas(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredIdeas.assignAll(ideas);
    } else {
      filteredIdeas.assignAll(
        ideas.where((idea) =>
            idea.title.toLowerCase().contains(query.toLowerCase())
        ).toList(),
      );
    }
  }

  int get totalIdeas => ideas.length;

  double get avgScore =>
      ideas.isEmpty ? 0 : ideas.map((e) => e.score).reduce((a, b) => a + b) / ideas.length;

  int get bestScore =>
      ideas.isEmpty ? 0 : ideas.map((e) => e.score).reduce((a, b) => a > b ? a : b);

  void deleteIdea(IdeaModel idea) {
    allIdeas.remove(idea);
    applyFilters(); // 🔥 reapply filters
  }

  void compareIdea(IdeaModel idea) {
    Get.snackbar("Compare", "Compare feature coming soon");
  }

  void resetSearch() {
    isSearching.value = false;
    searchQuery.value = '';
    filteredIdeas.assignAll(ideas);
  }

  // Toggle Sort
  void setSort(SortType type) {
    selectedSort.value = type;
  }

  // Toggle Status
  void toggleStatus(IdeaStatus status) {
    if (selectedStatus.contains(status)) {
      selectedStatus.remove(status);
    } else {
      selectedStatus.add(status);
    }
  }

  // Set Score Range
  void setScoreRange(ScoreRange range) {
    selectedScoreRange.value = range;
  }

  // Reset Filters
  void resetFilters() {
    filteredIdeas.assignAll(allIdeas);
  }

  // Apply Filters (connect later with API / list)
  void applyFilters({
    String? status,
  }) {
    var temp = allIdeas.toList();

    if (status != null) {
      temp = temp.where((e) => e.status == status).toList();
    }

    filteredIdeas.assignAll(temp);
  }

  @override
  void onReady() {
    super.onReady();

    ever(Get.find<MainController>().currentIndex, (index) {
      // Assuming Idea tab index = 1 (adjust if different)
      if (index != 1) {
        resetSearch();
      }
    });
  }


}