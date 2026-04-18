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
  var allIdeas = <IdeaModel>[].obs;       // MASTER DATA
  var filteredIdeas = <IdeaModel>[].obs;  // UI DATA

  var isSearching = false.obs;
  var searchQuery = ''.obs;

  final selectedSort = SortType.highest.obs;
  final selectedStatus = <IdeaStatus>{}.obs;
  final selectedScoreRange = Rxn<ScoreRange>();

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    final data = [
      IdeaModel(
        title: "Eco-Friendly Logistics",
        description: "AI routing for electric fleets",
        category: "SUSTAINABILITY",
        score: 88,
        status: "Analyzed",
        date: "OCT 24, 2023",
        tag: "High Potential",
      ),
      IdeaModel(
        title: "Micro-SaaS Escrow",
        description: "Fintech escrow system",
        category: "FINTECH",
        score: 62,
        status: "Processing",
        date: "OCT 22, 2023",
        tag: "",
      ),
      IdeaModel(
        title: "Biometric Sleep Tuning",
        description: "Health optimization system",
        category: "HEALTH TECH",
        score: 92,
        status: "Analyzed",
        date: "OCT 20, 2023",
        tag: "Moonshot",
      ),
      IdeaModel(
        title: "Civic DAOs",
        description: "Web3 governance",
        category: "WEB3",
        score: 45,
        status: "Analyzed",
        date: "OCT 18, 2023",
        tag: "Low Feasibility",
      ),
    ];

    allIdeas.assignAll(data);

    // 🔥 IMPORTANT: default = show ALL
    filteredIdeas.assignAll(allIdeas);
  }

  // 🔍 SEARCH
  void searchIdeas(String query) {
    searchQuery.value = query;
    applyFilters(); // 🔥 ALWAYS call this
  }

  // 🧠 MAIN FILTER ENGINE (THIS IS THE CORE FIX)
  void applyFilters() {
    var temp = allIdeas.toList();

    // 🔍 SEARCH
    if (searchQuery.value.isNotEmpty) {
      temp = temp.where((idea) =>
          idea.title.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }

    // 📊 STATUS
    if (selectedStatus.isNotEmpty) {
      temp = temp.where((idea) {
        return selectedStatus.any((status) =>
        idea.status.toLowerCase() == status.name
        );
      }).toList();
    }

    // 🎯 SCORE
    if (selectedScoreRange.value != null) {
      temp = temp.where((idea) {
        switch (selectedScoreRange.value!) {
          case ScoreRange.low:
            return idea.score <= 40;
          case ScoreRange.mid:
            return idea.score > 40 && idea.score <= 70;
          case ScoreRange.high:
            return idea.score > 70;
        }
      }).toList();
    }

    // 🔽 SORT
    switch (selectedSort.value) {
      case SortType.highest:
        temp.sort((a, b) => b.score.compareTo(a.score));
        break;
      case SortType.lowest:
        temp.sort((a, b) => a.score.compareTo(b.score));
        break;
      case SortType.recent:
        temp = temp.reversed.toList();
        break;
    }

    filteredIdeas.assignAll(temp);
  }

  // 🎛 CONTROLS
  void setSort(SortType type) {
    selectedSort.value = type;
  }

  void toggleStatus(IdeaStatus status) {
    if (selectedStatus.contains(status)) {
      selectedStatus.remove(status);
    } else {
      selectedStatus.add(status);
    }
  }

  void setScoreRange(ScoreRange range) {
    if (selectedScoreRange.value == range) {
      selectedScoreRange.value = null; // 🔥 toggle OFF
    } else {
      selectedScoreRange.value = range;
    }
  }
  // 🔄 RESET (REAL RESET)
  void resetFilters() {
    selectedSort.value = SortType.highest;
    selectedStatus.clear();
    selectedScoreRange.value = null;
    searchQuery.value = '';

    filteredIdeas.assignAll(allIdeas);

    Get.back(); // close sheet
  }

  // 🗑 DELETE
  void deleteIdea(IdeaModel idea) {
    allIdeas.remove(idea);
    applyFilters(); // 🔥 keep filters consistent
  }

  void compareIdea(IdeaModel idea) {
    Get.snackbar("Compare", "Coming soon");
  }

  void resetSearch() {
    isSearching.value = false;
    searchQuery.value = '';

    applyFilters(); // 🔥 IMPORTANT: re-run full pipeline
  }



  // 📊 STATS
  int get totalIdeas => filteredIdeas.length;

  double get avgScore =>
      filteredIdeas.isEmpty ? 0 :
      filteredIdeas.map((e) => e.score).reduce((a, b) => a + b) / filteredIdeas.length;

  int get bestScore =>
      filteredIdeas.isEmpty ? 0 :
      filteredIdeas.map((e) => e.score).reduce((a, b) => a > b ? a : b);
}