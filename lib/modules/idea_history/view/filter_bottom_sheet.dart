import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:startup_lense/modules/idea_history/controller/Idea_history_controller.dart';

class FilterBottomSheet extends GetView<IdeaHistoryController> {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        top: false,
        bottom: true,
        child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom + 12,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFF0B0F19),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Refine Search",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(width: double.infinity, child: _buildSortSection()),
                  const SizedBox(height: 24),

                  SizedBox(width: double.infinity, child: _buildStatusSection()),
                  const SizedBox(height: 24),

                  SizedBox(width: double.infinity, child: _buildScoreSection()),
                  const SizedBox(height: 30),

                  _buildActions(),
                ],
              ),
            )
        )
    );

  }

  // 🔷 SORT
  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle("SORT BY"),
        const SizedBox(height: 12),

        Obx(() => Wrap(
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children: [
            _chip("Highest Score",
                controller.selectedSort.value == SortType.highest, () {
                  controller.setSort(SortType.highest);
                }),
            _chip("Lowest Score",
                controller.selectedSort.value == SortType.lowest, () {
                  controller.setSort(SortType.lowest);
                }),
            _chip("Most Recent",
                controller.selectedSort.value == SortType.recent, () {
                  controller.setSort(SortType.recent);
                }),
          ],
        )),
      ],
    );
  }

  // 🔷 STATUS
  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle("STATUS"),
        const SizedBox(height: 12),

        Obx(() => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _chipWithIcon(
              "Analyzed",
              Icons.check_circle,
              controller.selectedStatus.contains(IdeaStatus.analyzed),
                  () => controller.toggleStatus(IdeaStatus.analyzed),
            ),
            _chipWithIcon(
              "Processing",
              Icons.hourglass_bottom,
              controller.selectedStatus.contains(IdeaStatus.processing),
                  () => controller.toggleStatus(IdeaStatus.processing),
            ),
          ],
        )),
      ],
    );
  }

  // 🔷 SCORE RANGE
  Widget _buildScoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle("SCORE RANGE"),
        const SizedBox(height: 12),

        Obx(() => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _chip("0 - 40",
                controller.selectedScoreRange.value == ScoreRange.low, () {
                  controller.setScoreRange(ScoreRange.low);
                }),
            _chip("41 - 70",
                controller.selectedScoreRange.value == ScoreRange.mid, () {
                  controller.setScoreRange(ScoreRange.mid);
                }),
            _chip("71 - 100",
                controller.selectedScoreRange.value == ScoreRange.high, () {
                  controller.setScoreRange(ScoreRange.high);
                }),
          ],
        )),
      ],
    );
  }

  // 🔷 ACTION BUTTONS
  Widget _buildActions() {
    return Row(
      children: [
        TextButton(
          onPressed: controller.resetFilters,
          child: const Text(
            "Reset All",
            style: TextStyle(color: Colors.white54),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: controller.applyFilters,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF06B6D4),
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x5506B6D4),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              "Apply Filters",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🔷 CHIP (REUSABLE)
  Widget _chip(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minWidth: 110),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF4F46E5)
              : const Color(0xFF111827),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.white12,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  // 🔷 CHIP WITH ICON
  Widget _chipWithIcon(
      String text, IconData icon, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minWidth: 140),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF06B6D4) : Colors.white12,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18,
                color: selected
                    ? const Color(0xFF06B6D4)
                    : Colors.white54),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color:
                selected ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔷 SECTION TITLE
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white38,
        letterSpacing: 1.2,
        fontSize: 12,
      ),
    );
  }

}