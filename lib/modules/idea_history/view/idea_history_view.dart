import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:startup_lense/modules/idea_history/controller/Idea_history_controller.dart';
import 'package:startup_lense/modules/idea_history/view/filter_bottom_sheet.dart';
import 'package:startup_lense/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';

class IdeaHistoryView extends GetView<IdeaHistoryController> {
  const IdeaHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: _fab(),
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            _statsSection(),
            _sectionHeader(),          // ✅ now reactive
            Expanded(child: _ideasList()),
          ],
        ),
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────
  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (controller.isSearching.value) {
          return Row(
            children: [
              GestureDetector(
                onTap: controller.resetSearch,
                child: const Icon(Icons.arrow_back,
                    color: AppColors.secondaryText),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    autofocus: true,
                    onChanged: controller.searchIdeas,
                    style: const TextStyle(color: AppColors.primaryText),
                    decoration: const InputDecoration(
                      hintText: "Search idea by name...",
                      hintStyle: TextStyle(color: AppColors.secondaryText),
                      border: InputBorder.none,
                      prefixIcon:
                      Icon(Icons.search, color: AppColors.secondaryText),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            const Icon(Icons.bolt, color: AppColors.accent, size: 26),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ).createShader(bounds),
              child: const Text(
                "Your Ideas",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => controller.isSearching.value = true,
              child:
              const Icon(Icons.search, color: AppColors.secondaryText),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.tune_rounded,
                  color: AppColors.secondaryText),
              onPressed: _openFilter,
            ),
          ],
        );
      }),
    );
  }

  // ─── STATS ───────────────────────────────────────────────
  Widget _statsSection() {
    return SizedBox(
      height: 110,
      child: Obx(() {
        if (controller.isStatsLoading.value) {
          return ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: List.generate(3, (_) => _statCardSkeleton()),
          );
        }
        return ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _statCard("TOTAL IDEAS", controller.statTotal.value.toString()),
            _statCard("AVG. SCORE",
                controller.statAvgScore.value.toStringAsFixed(0)),
            _statCard(
                "BEST SCORE", controller.statBestScore.value.toString()),
          ],
        );
      }),
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 11,
                  letterSpacing: 1)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _statCardSkeleton() {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(width: 80, height: 11, radius: 4),
          const Spacer(),
          _shimmerBox(width: 50, height: 26, radius: 6),
        ],
      ),
    );
  }

  // ─── SECTION HEADER ──────────────────────────────────────
  // ✅ FIX: reactive — shows active sort label
  Widget _sectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Obx(() {
        final sortLabel = switch (controller.selectedSort.value) {
          SortType.highest => "HIGHEST SCORE",
          SortType.lowest  => "LOWEST SCORE",
          SortType.recent  => "MOST RECENT",
        };
        return Row(
          children: [
            const Text("Library",
                style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600)),
            const Spacer(),
            Text("SORTED BY $sortLabel",
                style: const TextStyle(
                    color: AppColors.secondaryText, fontSize: 12)),
          ],
        );
      }),
    );
  }

  // ─── IDEAS LIST ──────────────────────────────────────────
  Widget _ideasList() {
    return Obx(() {
      // ── Initial load skeleton ──
      if (controller.isLoading.value) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: List.generate(5, (_) => _ideaCardSkeleton()),
        );
      }

      // ── Empty state ──
      if (controller.filteredIdeas.isEmpty) {
        return _emptyState();
      }

      // ── Populated list with pagination ──
      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels >=
              scroll.metrics.maxScrollExtent - 200) {
            controller.loadMore();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.filteredIdeas.length + 1, // +1 for footer
          itemBuilder: (_, i) {
            // ── Pagination footer ──
            if (i == controller.filteredIdeas.length) {
              return Obx(() {
                if (controller.isLoadingMore.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF06B6D4),
                        ),
                      ),
                    ),
                  );
                }
                if (!controller.hasMore.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "— All ideas loaded —",
                        style: TextStyle(
                            color: Colors.white24, fontSize: 12),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              });
            }

            final idea = controller.filteredIdeas[i];
            return Dismissible(
              key: Key(idea.id),
              direction: DismissDirection.horizontal,
              background: _swipeRightBg(),
              secondaryBackground: _swipeLeftBg(),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await _confirmDelete();
                }
                // swipe right = compare, don't dismiss the tile
                controller.compareIdea(idea);
                return false;
              },
              // In _ideasList(), inside Dismissible:

              onDismissed: (direction) async {
                await controller.deleteIdea(idea);  // ✅ was missing await
              },
              child: _ideaCard(idea),
            );
          },
        ),
      );
    });
  }

  // ─── IDEA CARD ───────────────────────────────────────────
  Widget _ideaCard(IdeaModel idea) {
    // ✅ FIX: safe cast — arguments may be null or not a Map
    final args = Get.arguments;
    final isSelecting =
    (args is Map) ? (args["isSelecting"] ?? false) : false;

    return GestureDetector(
      onTap: () {
        if (isSelecting) {
          Get.back(result: idea);
        } else {
          controller.openIdea(idea);  // ← was: Get.toNamed('/idea-result', arguments: idea)
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(idea.category,
                          style: const TextStyle(
                              color: AppColors.accent, fontSize: 10)),
                      const SizedBox(height: 4),
                      Text(idea.title,
                          style: const TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(
                        idea.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.secondaryText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _scoreBadge(idea.score, _getScoreColor(idea.score)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _statusChip(idea.status),
                if (idea.tag.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _tagChip(idea.tag),
                ],
                const Spacer(),
                Text(idea.date,
                    style: const TextStyle(
                        color: AppColors.secondaryText, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── IDEA CARD SKELETON ──────────────────────────────────
  Widget _ideaCardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(width: 60, height: 10, radius: 4),
                    const SizedBox(height: 8),
                    _shimmerBox(width: 160, height: 16, radius: 4),
                    const SizedBox(height: 8),
                    _shimmerBox(width: double.infinity, height: 12, radius: 4),
                    const SizedBox(height: 4),
                    _shimmerBox(width: 120, height: 12, radius: 4),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _shimmerBox(width: 64, height: 32, radius: 20),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _shimmerBox(width: 72, height: 24, radius: 10),
              const SizedBox(width: 8),
              _shimmerBox(width: 80, height: 24, radius: 10),
              const Spacer(),
              _shimmerBox(width: 70, height: 11, radius: 4),
            ],
          ),
        ],
      ),
    );
  }

  // ─── EMPTY STATE ─────────────────────────────────────────
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lightbulb_outline,
              size: 60, color: AppColors.secondaryText),
          const SizedBox(height: 16),
          const Text("No startup ideas yet",
              style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.black),
            onPressed: () => Get.toNamed('/idea-submission'),
            child: const Text("Create Your First Idea"),
          ),
        ],
      ),
    );
  }

  // ─── DIALOGS & BACKGROUNDS ───────────────────────────────
  Future<bool?> _confirmDelete() {
    return Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("Delete Idea",
            style: TextStyle(color: AppColors.primaryText)),
        content: const Text("Are you sure?",
            style: TextStyle(color: AppColors.secondaryText)),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text("Delete",
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _swipeRightBg() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.cyan.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.compare_arrows, color: Colors.cyan),
    );
  }

  Widget _swipeLeftBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.delete, color: Colors.red),
    );
  }

  // ─── BADGES & CHIPS ──────────────────────────────────────
  Widget _scoreBadge(num score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("$score/100",
          style:
          TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status == "Analyzed"
            ? Colors.green.withOpacity(0.2)
            : Colors.cyan.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(status,
          style:
          const TextStyle(color: AppColors.primaryText, fontSize: 11)),
    );
  }

  Widget _tagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(tag,
          style:
          const TextStyle(color: AppColors.primaryText, fontSize: 11)),
    );
  }

  // ─── FAB ─────────────────────────────────────────────────
  Widget _fab() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
        ),
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        heroTag: "idea_history_fab",
        elevation: 0,
        onPressed: () => Get.toNamed(AppRoutes.IDEA_SUBMISSION),
        child: const Icon(Icons.add),
      ),
    );
  }

  // ─── HELPERS ─────────────────────────────────────────────
  Color _getScoreColor(num score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  void _openFilter() {
    Get.bottomSheet(
      const FilterBottomSheet(),
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B0F19),
    );
  }

  Widget _shimmerBox(
      {required double width, required double height, double radius = 4}) {
    return _ShimmerBox(width: width, height: height, radius: radius);
  }
}

// ─── Animated shimmer box ─────────────────────────────────────
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