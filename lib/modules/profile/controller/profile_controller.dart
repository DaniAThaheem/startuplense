import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:startup_lense/data/repositories/auth_repository.dart';
import 'package:startup_lense/data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final _repo     = ProfileRepository();
  final _authRepo = AuthRepository();

  static const _fallbackAvatar =
      'https://ui-avatars.com/api/?background=4F46E5&color=fff&size=200&name=User';

  // ─── State ────────────────────────────────────────────────
  var isLoading      = true.obs;
  var isStatsLoading = true.obs;
  var isLoggingOut   = false.obs;

  // ─── Profile ──────────────────────────────────────────────
  var name       = ''.obs;
  var email      = ''.obs;
  var avatarUrl  = _fallbackAvatar.obs;
  var badge      = 'NEWCOMER'.obs;

  // ─── Analytics ────────────────────────────────────────────
  var totalIdeas   = 0.obs;
  var bestScore    = 0.obs;
  var avgScore     = '0'.obs;
  var lastActivity = 'N/A'.obs;

  // ─── AI Insight ───────────────────────────────────────────
  var insight = 'Start submitting ideas to unlock your AI insight.'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
    _loadStats();
  }

  // ─── Step 1: Load from Auth first, then sync Firestore ────
  void _loadProfile() {
    // ── Read Firebase Auth immediately (instant, no network) ─
    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser != null) {
      name.value  = authUser.displayName ?? 'User';
      email.value = authUser.email       ?? '';

      final photo = authUser.photoURL;
      avatarUrl.value = (photo != null && photo.isNotEmpty)
          ? photo
          : _buildAvatarUrl(authUser.displayName ?? 'User');

      isLoading.value = false;
    }

    // ── Then listen to Firestore for any overrides ────────────
    _repo.profileStream().listen(
          (doc) {
        if (!doc.exists) return;
        final data = doc.data()!;

        final fsName  = data['displayName'] as String?;
        final fsEmail = data['email']       as String?;
        final fsPhoto = data['photoUrl']    as String?;

        if (fsName  != null && fsName.isNotEmpty)  name.value      = fsName;
        if (fsEmail != null && fsEmail.isNotEmpty) email.value     = fsEmail;
        if (fsPhoto != null && fsPhoto.isNotEmpty) avatarUrl.value = fsPhoto;

        isLoading.value = false;
      },
      onError: (_) => isLoading.value = false,
    );
  }

  // ─── Step 2: Load stats from ideas collection ─────────────
  Future<void> _loadStats() async {
    isStatsLoading.value = true;
    try {
      final stats = await _repo.fetchStats();

      totalIdeas.value   = stats['totalIdeas']   as int;
      bestScore.value    = stats['bestScore']     as int;
      avgScore.value     = (stats['avgScore'] as double).toStringAsFixed(0);
      lastActivity.value = stats['lastActivity']  as String;

      badge.value = _repo.resolveBadge(
        bestScore.value,
        totalIdeas.value,
      );

      _updateInsight();
    } catch (_) {
    } finally {
      isStatsLoading.value = false;
    }
  }

  // ─── Insight logic ────────────────────────────────────────
  void _updateInsight() {
    final best  = bestScore.value;
    final total = totalIdeas.value;

    if (total == 0) {
      insight.value =
      'Submit your first idea to unlock AI-powered insights.';
    } else if (best >= 85) {
      insight.value =
      'Outstanding performance! Your ideas show strong market viability. Keep refining your top concept.';
    } else if (best >= 70) {
      insight.value =
      'Your idea quality is improving. Focus on differentiation and financial clarity for a higher score.';
    } else if (best >= 50) {
      insight.value =
      'Good start. Try refining problem clarity and target audience to boost your evaluation score.';
    } else {
      insight.value =
      'Early stage insights: strengthen your value proposition and market research for better results.';
    }
  }

  // ─── Avatar URL builder ───────────────────────────────────
  String _buildAvatarUrl(String displayName) {
    final encoded = Uri.encodeComponent(displayName);
    return 'https://ui-avatars.com/api/?background=4F46E5&color=fff&size=200&name=$encoded';
  }

  // ─── Quick Actions ────────────────────────────────────────
  void goToAllIdeas() => Get.toNamed('/idea-history');
  void goToCompare()  => Get.toNamed('/compare');
  void goToImprove()  => Get.toNamed('/improve-idea',
      arguments: {'fromProfile': true});

  // ─── Logout ───────────────────────────────────────────────
  void logout() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to log out?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () async {
        Get.back();
        try {
          isLoggingOut.value = true;
          await _authRepo.logout();
          Get.offAllNamed('/login');
        } catch (e) {
          Get.snackbar(
            'Error',
            e.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
        } finally {
          isLoggingOut.value = false;
        }
      },
    );
  }
}