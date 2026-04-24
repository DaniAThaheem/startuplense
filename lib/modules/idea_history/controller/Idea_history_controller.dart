import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:startup_lense/data/repositories/idea_repository.dart';
import 'package:flutter/material.dart';

enum SortType { highest, lowest, recent }
enum IdeaStatus { analyzed, processing }
enum ScoreRange { low, mid, high }

class IdeaModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final num score;
  final String status;
  final String date;
  final String tag;
  final DocumentSnapshot snapshot; // pagination cursor

  IdeaModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.score,
    required this.status,
    required this.date,
    required this.tag,
    required this.snapshot,
  });

  factory IdeaModel.fromMap(Map<String, dynamic> map) {
    return IdeaModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'GENERAL',
      score: map['score'] ?? 0,
      status: map['status'] ?? 'Processing',
      date: map['date'] ?? '',
      tag: map['tag'] ?? '',
      snapshot: map['snapshot'] as DocumentSnapshot,
    );
  }
}

class IdeaHistoryController extends GetxController {
  final _repo = IdeaRepository();
  static const _pageSize = 10;

  // ─── Ideas ───────────────────────────────────────────────
  var allIdeas = <IdeaModel>[].obs;      // all loaded pages
  var filteredIdeas = <IdeaModel>[].obs; // filtered + sorted view

  // ─── Pagination ──────────────────────────────────────────
  DocumentSnapshot? _lastDoc;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;

  // ─── Stats (from Firestore aggregation) ──────────────────
  var statTotal = 0.obs;
  var statAvgScore = 0.0.obs;
  var statBestScore = 0.obs;
  var isStatsLoading = true.obs;

  // ─── Page Loading ─────────────────────────────────────────
  var isLoading = true.obs;

  // ─── Filters ─────────────────────────────────────────────
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  final selectedSort = SortType.recent.obs;
  final selectedStatus = <IdeaStatus>{}.obs;
  final selectedScoreRange = Rxn<ScoreRange>();

  @override
  void onInit() {
    super.onInit();
    _loadFirstPage();
    _loadStats();
  }

  // ─── LOAD FIRST PAGE ─────────────────────────────────────
  Future<void> _loadFirstPage() async {
    isLoading.value = true;
    _lastDoc = null;
    hasMore.value = true;

    try {
      final results = await _repo.getUserIdeasPaginated(limit: _pageSize);
      final models = results.map(IdeaModel.fromMap).toList();

      allIdeas.assignAll(models);

      if (models.isNotEmpty) {
        _lastDoc = models.last.snapshot;
      }

      hasMore.value = models.length == _pageSize;
      applyFilters();
    } catch (e) {
      Get.snackbar("Error", "Failed to load ideas.");
    } finally {
      isLoading.value = false;
    }
  }

  // ─── LOAD NEXT PAGE (called on scroll end) ────────────────
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;

    try {
      final results = await _repo.getUserIdeasPaginated(
        lastDoc: _lastDoc,
        limit: _pageSize,
      );
      final models = results.map(IdeaModel.fromMap).toList();

      allIdeas.addAll(models);

      if (models.isNotEmpty) {
        _lastDoc = models.last.snapshot;
      }

      hasMore.value = models.length == _pageSize;
      applyFilters();
    } catch (e) {
      Get.snackbar("Error", "Failed to load more ideas.");
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ─── STATS ───────────────────────────────────────────────
  Future<void> _loadStats() async {
    isStatsLoading.value = true;
    try {
      final stats = await _repo.getUserIdeaStats();
      statTotal.value = stats['total'] as int;
      statAvgScore.value = stats['avgScore'] as double;
      statBestScore.value = stats['bestScore'] as int;
    } catch (_) {
    } finally {
      isStatsLoading.value = false;
    }
  }

  // ─── FILTER ENGINE ───────────────────────────────────────
  void applyFilters() {
    var temp = allIdeas.toList();

    if (searchQuery.value.isNotEmpty) {
      temp = temp.where((idea) =>
          idea.title.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }

    if (selectedStatus.isNotEmpty) {
      temp = temp.where((idea) {
        return selectedStatus.any((s) =>
        idea.status.toLowerCase() == s.name.toLowerCase());
      }).toList();
    }

    if (selectedScoreRange.value != null) {
      temp = temp.where((idea) {
        switch (selectedScoreRange.value!) {
          case ScoreRange.low:  return idea.score <= 40;
          case ScoreRange.mid:  return idea.score > 40 && idea.score <= 70;
          case ScoreRange.high: return idea.score > 70;
        }
      }).toList();
    }

    switch (selectedSort.value) {
      case SortType.highest:
        temp.sort((a, b) => b.score.compareTo(a.score));
        break;
      case SortType.lowest:
        temp.sort((a, b) => a.score.compareTo(b.score));
        break;
      case SortType.recent:
        break; // already ordered by Firestore descending
    }

    filteredIdeas.assignAll(temp);
  }

  // ─── SEARCH ──────────────────────────────────────────────
  void searchIdeas(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void resetSearch() {
    isSearching.value = false;
    searchQuery.value = '';
    applyFilters();
  }

  // ─── FILTER CONTROLS ─────────────────────────────────────
  void setSort(SortType type) => selectedSort.value = type;

  void toggleStatus(IdeaStatus status) {
    if (selectedStatus.contains(status)) {
      selectedStatus.remove(status);
    } else {
      selectedStatus.add(status);
    }
  }

  void setScoreRange(ScoreRange range) {
    selectedScoreRange.value =
    selectedScoreRange.value == range ? null : range;
  }

  void resetFilters() {
    selectedSort.value = SortType.recent;
    selectedStatus.clear();
    selectedScoreRange.value = null;
    searchQuery.value = '';
    applyFilters();
    Get.back();
  }

  // ─── DELETE ──────────────────────────────────────────────
  // In IdeaHistoryController

  Future<void> deleteIdea(IdeaModel idea) async {
    // ✅ Optimistic update — remove from UI instantly
    allIdeas.removeWhere((i) => i.id == idea.id);
    applyFilters();

    try {
      await _repo.deleteIdea(idea.id);

      // ✅ Refresh stats after deletion
      await _loadStats();

      Get.snackbar(
        "Deleted",
        "\"${idea.title}\" has been removed.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.15),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        mainButton: TextButton(
          onPressed: () {
            // ⚠️ Undo is complex with Firestore batch —
            // simplest approach: reload the page
            _loadFirstPage();
            _loadStats();
            Get.closeCurrentSnackbar();
          },
          child: const Text("UNDO",
              style: TextStyle(color: Color(0xFF06B6D4))),
        ),
      );
    } catch (e) {
      // ✅ Rollback — re-fetch if Firestore delete failed
      Get.snackbar(
        "Error",
        "Failed to delete idea. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.15),
        colorText: Colors.white,
      );
      await _loadFirstPage(); // restore list to actual Firestore state
    }
  }

  void compareIdea(IdeaModel idea) {
    Get.snackbar("Compare", "Coming soon");
  }


  void openIdea(IdeaModel idea) async {
    if (idea.status == 'Processing') {
      _showProcessingSnackbar();
      return;
    }

    try {
      final fullIdea = await _repo.getIdeaById(idea.id);
      if (fullIdea == null) {
        _showErrorSnackbar('Idea not found');
        return;
      }
      Get.toNamed('/analysis', arguments: fullIdea);
    } catch (e) {
      _showErrorSnackbar('Failed to load idea details');
    }
  }

  void _showProcessingSnackbar() {
    Get.snackbar(
      'Analysis In Progress',
      'Your idea is still being analyzed. Please check back shortly.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withOpacity(0.15),
      colorText: Colors.white,
      icon: const Icon(Icons.hourglass_top_rounded, color: Colors.orange),
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.15),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}