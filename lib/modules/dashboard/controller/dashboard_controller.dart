import 'dart:async';
import 'package:get/get.dart';
import 'package:startup_lense/data/repositories/idea_repository.dart';
import 'package:startup_lense/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  // ─── Ideas State ─────────────────────────────────────────
  var ideas = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  // ─── Stats State (from users collection) ─────────────────
  var totalIdeas = 0.obs;
  var ideasAnalyzed = 0.obs;
  var ideasInProcessing = 0.obs;
  var isStatsLoading = true.obs;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  StreamSubscription? _ideasSubscription;
  StreamSubscription? _statsSubscription;

  // ─── Lifecycle ───────────────────────────────────────────
  @override
  void onReady() {
    super.onReady();
    _listenToIdeas();
    _listenToUserStats();
  }

  @override
  void onClose() {
    _ideasSubscription?.cancel();
    _statsSubscription?.cancel();
    super.onClose();
  }

  // ─── Stream: Recent 5 Ideas ───────────────────────────────
  void _listenToIdeas() {
    isLoading.value = true;

    _ideasSubscription = IdeaRepository().getUserIdeas().listen(
          (fetchedIdeas) {
        ideas.assignAll(fetchedIdeas);
        isLoading.value = false;

        // Derive "in processing" count from the fetched 5 ideas
        // OR use a separate Firestore query — see _listenToUserStats below
        _updateProcessingCount();
      },
      onError: (e) {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "Failed to load ideas. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  // ─── Stream: User Stats from users collection ─────────────
  void _listenToUserStats() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    isStatsLoading.value = true;

    _statsSubscription = _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen(
          (doc) {
        if (doc.exists) {
          final stats = doc.data()?['stats'] as Map<String, dynamic>? ?? {};
          totalIdeas.value = (stats['totalIdeas'] ?? 0) as int;
          ideasAnalyzed.value = (stats['ideasAnalyzed'] ?? 0) as int;

          // Processing = total - analyzed (derived, not stored separately)
          final processing = totalIdeas.value - ideasAnalyzed.value;
          ideasInProcessing.value = processing.clamp(0, totalIdeas.value);
        }
        isStatsLoading.value = false;
      },
      onError: (e) {
        isStatsLoading.value = false;
      },
    );
  }

  /// Optionally re-derive processing from the recent-ideas list if you want
  /// a quick local count while Firestore loads.
  void _updateProcessingCount() {
    if (!isStatsLoading.value) return; // already got real data from Firestore
    final processing =
        ideas.where((idea) => idea['status'] == 'Processing').length;
    ideasInProcessing.value = processing;
  }

  // ─── Actions ─────────────────────────────────────────────
  void onAddIdea() async {
    final result = await Get.toNamed(AppRoutes.IDEA_SUBMISSION);
    if (result != null) {
      Get.snackbar(
        "Success",
        "Idea submitted for analysis!",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onViewAll() {
    Get.toNamed("/idea-history");
  }

  void openIdea(Map idea) async {
    if (_isProcessing(idea)) {
      _showProcessingSnackbar();
      return;
    }

    final ideaId = idea['id'] as String?;
    if (ideaId == null) return;

    try {
      final fullIdea = await IdeaRepository().getIdeaById(ideaId);
      if (fullIdea == null) {
        _showErrorSnackbar('Idea not found');
        return;
      }
      Get.toNamed('/analysis', arguments: fullIdea);
    } catch (e) {
      _showErrorSnackbar('Failed to load idea details');
    }
  }

// ─── Private Helpers ─────────────────────────────────────────────────────

  bool _isProcessing(Map idea) => idea['status'] == 'Processing';

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

  void onIdeaLongPress(Map idea) {
    // Handled in View via bottom sheet
  }

  // In DashboardController

  Future<void> deleteIdea(Map idea) async {
    final ideaId = idea['id'] as String?;
    if (ideaId == null) return;

    // ✅ Optimistic update — remove from UI instantly
    ideas.removeWhere((i) => i['id'] == ideaId);

    try {
      await IdeaRepository().deleteIdea(ideaId);

      Get.snackbar(
        "Deleted",
        "\"${idea['title']}\" has been removed.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.15),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      // ✅ Rollback — Firestore failed, restore stream will auto-correct
      Get.snackbar(
        "Error",
        "Failed to delete idea. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.15),
        colorText: Colors.white,
      );
    }
  }
}