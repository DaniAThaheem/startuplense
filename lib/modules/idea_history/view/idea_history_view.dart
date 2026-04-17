import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/idea_history_controller.dart';

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
            _sectionHeader(),
            Expanded(child: _ideasList()),
          ],
        ),
      ),
    );
  }

  // 🔥 APP BAR
  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.auto_graph, color: AppColors.primaryText),
          const SizedBox(width: 8),
          const Text(
            "Your Ideas",
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(Icons.search, color: AppColors.secondaryText),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: _openFilter,
            child: const Icon(Icons.tune, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  // 🔥 STATS
  Widget _statsSection() {
    return SizedBox(
      height: 90,
      child: Obx(() => ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _statCard("TOTAL IDEAS", controller.totalIdeas.toString()),
          _statCard("AVG. SCORE", controller.avgScore.toStringAsFixed(0)),
          _statCard("BEST SCORE", controller.bestScore.toString()),
        ],
      )),
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.secondaryText, fontSize: 10)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // 🔥 HEADER
  Widget _sectionHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text("Library",
              style: TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w600)),
          Spacer(),
          Text("SORTED BY SCORE",
              style: TextStyle(
                  color: AppColors.secondaryText, fontSize: 12)),
        ],
      ),
    );
  }

  // 🔥 LIST
  Widget _ideasList() {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.ideas.length,
      itemBuilder: (_, i) {
        final idea = controller.ideas[i];
        return _ideaCard(idea);
      },
    ));
  }

  // 🔥 IDEA CARD
  Widget _ideaCard(IdeaModel idea) {
    Color scoreColor = idea.score >= 80
        ? Colors.green
        : idea.score >= 60
        ? Colors.orange
        : Colors.red;

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
          // TOP ROW
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
                  ],
                ),
              ),
              _scoreBadge(idea.score, scoreColor),
            ],
          ),

          const SizedBox(height: 12),

          // STATUS + TAG
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
          )
        ],
      ),
    );
  }

  Widget _scoreBadge(int score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("$score/100",
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
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
          style: const TextStyle(color: AppColors.primaryText, fontSize: 11)),
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
          style: const TextStyle(color: AppColors.primaryText, fontSize: 11)),
    );
  }

  // 🔥 FAB
  Widget _fab() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
        ),
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  // 🔥 FILTER SHEET
  void _openFilter() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Text("Filter Options (Coming Soon)",
            style: TextStyle(color: AppColors.primaryText)),
      ),
    );
  }
}