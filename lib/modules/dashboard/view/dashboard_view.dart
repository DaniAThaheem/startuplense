import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:startup_lense/modules/main/controller/main_controller.dart';
import 'package:startup_lense/routes/app_routes.dart';
import '../controller/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF06B6D4).withOpacity(0.5),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
            const BoxShadow(
              color: Colors.black54,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: controller.onAddIdea,
          heroTag: "dashboard_fab",
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, size: 28),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 24),
              _insightSection(),
              const SizedBox(height: 24),
              _heroSection(),
              const SizedBox(height: 24),
              _recentSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // ─── TOP BAR ──────────────────────────────────────────────
  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.bolt, color: Color(0xFF06B6D4), size: 30),

        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
          ).createShader(bounds),
          child: const Text(
            "StartupLense",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        Row(
          children: [
            Stack(
              children: [
                const Icon(Icons.notifications_none, color: Colors.white70),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF06B6D4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Get.find<MainController>().changeIndex(3),
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF111827),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── INSIGHTS ─────────────────────────────────────────────
  Widget _insightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "INSIGHT SUMMARY",
          style: TextStyle(
            color: Color(0xFF06B6D4),
            fontSize: 14,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          // Show skeleton while EITHER ideas OR stats are loading
          if (controller.isLoading.value || controller.isStatsLoading.value) {
            return SizedBox(
              height: 144,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(3, (_) => _insightCardSkeleton()),
              ),
            );
          }

          // ✅ Real data from users collection (not just the 5 recent ideas)
          final total = controller.totalIdeas.value;
          final analyzed = controller.ideasAnalyzed.value;
          final processing = controller.ideasInProcessing.value;

          return SizedBox(
            height: 144,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _insightCard(Icons.lightbulb, "$total", "Total Ideas", "+$total"),
                _insightCard(Icons.bar_chart, "$analyzed", "Validated", "+$analyzed"),
                _insightCard(Icons.compare, "$processing", "Processing", "$processing"),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _insightCard(
      IconData icon, String value, String label, String growth) {
    return Container(
      width: Get.width * 0.6,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 22),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 6),
          Text(
            growth,
            style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Shimmer-style skeleton for insight cards while loading
  Widget _insightCardSkeleton() {
    return Container(
      width: Get.width * 0.6,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(width: 22, height: 22, radius: 4),
          const Spacer(),
          _shimmerBox(width: 60, height: 28, radius: 6),
          const SizedBox(height: 8),
          _shimmerBox(width: 90, height: 14, radius: 4),
          const SizedBox(height: 8),
          _shimmerBox(width: 40, height: 12, radius: 4),
        ],
      ),
    );
  }

  // ─── HERO ─────────────────────────────────────────────────
  Widget _heroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4F46E5).withOpacity(0.25),
            const Color(0xFF06B6D4).withOpacity(0.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Evaluate a New Startup Idea",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Get AI-powered analysis and market validation in seconds.",
            style: TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: controller.onAddIdea,
            child: Container(
              height: 52,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Submit New Idea",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── RECENT SECTION ───────────────────────────────────────
  Widget _recentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Evaluations",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: controller.onViewAll,
              child: const Text(
                "See All",
                style: TextStyle(
                    color: Color(0xFF06B6D4), fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Obx(() {
          // ── Loading state ──
          if (controller.isLoading.value) {
            return Column(
              children: List.generate(3, (_) => _ideaCardSkeleton()),
            );
          }

          // ── Empty state ──
          if (controller.ideas.isEmpty) {
            return _emptyState();
          }

          // ── Populated list ──
          return Column(
            children: controller.ideas.map((idea) {
              return _ideaCard(context, idea);
            }).toList(),
          );
        }),
      ],
    );
  }

  // ─── IDEA CARD ────────────────────────────────────────────
  Widget _ideaCard(BuildContext context, Map idea) {
    final isAnalyzed = idea["status"] == "Analyzed";

    return GestureDetector(
      onTap: () => controller.openIdea(idea),
      onLongPress: () => _showIdeaOptions(context, idea),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: title + score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    idea["title"] ?? "Untitled",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (idea["score"] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${idea["score"]}/100",
                      style: const TextStyle(
                          color: Color(0xFF06B6D4),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // Status chip
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isAnalyzed
                    ? Colors.green.withOpacity(0.15)
                    : Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                idea["status"] ?? "Unknown",
                style: TextStyle(
                    color: isAnalyzed ? Colors.green : Colors.orange,
                    fontSize: 12),
              ),
            ),

            const SizedBox(height: 10),

            // Bottom row: date + city
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(idea["createdAt"]),
                  style:
                  const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                Text(
                  idea["city"]?.isNotEmpty == true
                      ? idea["city"]
                      : "AI / Startup",
                  style:
                  const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── SKELETON CARD ────────────────────────────────────────
  Widget _ideaCardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 160, height: 16, radius: 4),
              _shimmerBox(width: 56, height: 26, radius: 20),
            ],
          ),
          const SizedBox(height: 12),
          _shimmerBox(width: 80, height: 24, radius: 20),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 70, height: 12, radius: 4),
              _shimmerBox(width: 70, height: 12, radius: 4),
            ],
          ),
        ],
      ),
    );
  }

  // ─── EMPTY STATE ──────────────────────────────────────────
  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 48,
            color: Colors.white.withOpacity(0.15),
          ),
          const SizedBox(height: 16),
          const Text(
            "No ideas yet",
            style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap the + button to submit your first startup idea.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ─── BOTTOM SHEET ─────────────────────────────────────────
  void _showIdeaOptions(BuildContext context, Map idea) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF111827),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Re-run Analysis",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed('/improve-idea', arguments: idea);
                },
              ),
              ListTile(
                title: const Text("Compare",
                    style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              // In _showIdeaOptions() — replace the Delete ListTile:

              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text("Delete", style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context); // close bottom sheet first

                  // ✅ Confirm before deleting
                  final confirmed = await Get.dialog<bool>(
                    AlertDialog(
                      backgroundColor: const Color(0xFF111827),
                      title: const Text(
                        "Delete Idea",
                        style: TextStyle(color: Colors.white),
                      ),
                      content: Text(
                        "Are you sure you want to delete \"${idea['title']}\"?",
                        style: const TextStyle(color: Colors.white54),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text("Cancel",
                              style: TextStyle(color: Colors.white54)),
                        ),
                        TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text("Delete",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await controller.deleteIdea(idea);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────

  /// Converts a Firestore Timestamp or DateTime to a readable relative string.
  String _formatDate(dynamic createdAt) {
    if (createdAt == null) return "Unknown";

    DateTime date;

    // Firestore Timestamp has a .toDate() method
    if (createdAt is DateTime) {
      date = createdAt;
    } else {
      try {
        date = createdAt.toDate();
      } catch (_) {
        return "Unknown";
      }
    }

    final diff = DateTime.now().difference(date);

    if (diff.inDays >= 1) return "${diff.inDays}d ago";
    if (diff.inHours >= 1) return "${diff.inHours}h ago";
    if (diff.inMinutes >= 1) return "${diff.inMinutes}m ago";
    return "Just now";
  }

  /// A pulsing shimmer-style placeholder box.
  Widget _shimmerBox(
      {required double width, required double height, double radius = 4}) {
    return _ShimmerBox(width: width, height: height, radius: radius);
  }
}

// ─── Shimmer box widget with animation ────────────────────────
class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox(
      {required this.width, required this.height, required this.radius});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _anim = Tween<double>(begin: 0.04, end: 0.12).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}