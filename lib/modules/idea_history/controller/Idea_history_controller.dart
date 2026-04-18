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
  var ideas = <IdeaModel>[].obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  var filteredIdeas = <IdeaModel>[].obs;

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
    ideas.assignAll([
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
    ]);
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
    ideas.remove(idea);
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
    selectedSort.value = SortType.highest;
    selectedStatus.clear();
    selectedScoreRange.value = ScoreRange.high;

    // ✅ IMPORTANT
    filteredIdeas.assignAll(ideas);
  }

  // Apply Filters (connect later with API / list)
  void applyFilters() {
    List<IdeaModel> tempList = List.from(ideas);

    // ✅ FILTER: STATUS
    if (selectedStatus.isNotEmpty) {
      tempList = tempList.where((idea) {
        if (selectedStatus.contains(IdeaStatus.analyzed) &&
            idea.status.toLowerCase() == "analyzed") {
          return true;
        }
        if (selectedStatus.contains(IdeaStatus.processing) &&
            idea.status.toLowerCase() == "processing") {
          return true;
        }
        return false;
      }).toList();
    }

    // ✅ FILTER: SCORE RANGE
    tempList = tempList.where((idea) {
      switch (selectedScoreRange.value) {
        case ScoreRange.low:
          return idea.score <= 40;
        case ScoreRange.mid:
          return idea.score > 40 && idea.score <= 70;
        case ScoreRange.high:
          return idea.score > 70;
      }
    }).toList();

    // ✅ SORT
    switch (selectedSort.value) {
      case SortType.highest:
        tempList.sort((a, b) => b.score.compareTo(a.score));
        break;
      case SortType.lowest:
        tempList.sort((a, b) => a.score.compareTo(b.score));
        break;
      case SortType.recent:
      // You can later replace with real DateTime parsing
        tempList = tempList.reversed.toList();
        break;
    }

    // ✅ APPLY RESULT
    filteredIdeas.assignAll(tempList);

    Get.back();
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