import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/improve_idea_controller.dart';

// 🔥 REUSABLE WIDGETS
import '../../idea_submission/widgets/section_title.dart';
import '../../idea_submission/widgets/glass_card.dart';
import '../../idea_submission/widgets/idea_input.dart';
import '../../idea_submission/widgets/idea_textarea.dart';
import '../../idea_submission/widgets/bottom_action_bar.dart';
import '../../idea_submission/widgets/suggestion_block.dart';

class IdeaImproveView extends GetView<IdeaImproveController> {
  const IdeaImproveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Refine Your Idea",
          style: TextStyle(
            color: Color(0xFF22D3EE),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ================= BODY =================
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyan),
            );
          }

          return Stack(
            children: [
              _buildContent(),
              BottomActionBar(
                scale: controller.scale,
                onTap: controller.saveImprovedIdea,
                label: "Save Improvements",
              ),
            ],
          );
        }),
      ),
    );
  }

  // ================= MAIN CONTENT =================
  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 SCORE OVERVIEW
          _scoreCard(),

          const SizedBox(height: 20),

          // 🔹 TITLE SECTION
          const SectionTitle("TITLE OPTIMIZATION"),

          GlassCard(
            child: Column(
              children: [
                IdeaInput(
                  controller: controller.titleController,
                  label: "Idea Title",
                  hint: "Refine your idea title",
                ),

                const SizedBox(height: 12),

                SuggestionBlock(
                  title: "AI Suggestion",
                  suggestion: controller.titleSuggestion.value,
                  reason: controller.titleReason.value,
                  onApply: controller.applyTitleSuggestion,
                )

              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 PROBLEM SECTION
          const SectionTitle("PROBLEM CLARITY"),

          GlassCard(
            child: Column(
              children: [
                IdeaTextarea(
                  controller: controller.problemController,
                  hint: "Improve problem clarity",
                ),

                const SizedBox(height: 12),

                SuggestionBlock(
                  title: "AI Suggestion",
                  suggestion: controller.titleSuggestion.value,
                  reason: controller.titleReason.value,
                  onApply: controller.applyTitleSuggestion,
                )

              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 MARKET SECTION (NEW 🔥)
          const SectionTitle("MARKET IMPROVEMENT"),

          GlassCard(
            child: Column(
              children: [
                IdeaInput(
                  controller: controller.marketController,
                  label: "Target Market",
                  hint: "Refine your audience",
                ),

                const SizedBox(height: 12),

                SuggestionBlock(
                  title: "AI Suggestion",
                  suggestion: controller.titleSuggestion.value,
                  reason: controller.titleReason.value,
                  onApply: controller.applyTitleSuggestion,
                )

              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 STRATEGY SECTION (NEW 🔥)
          const SectionTitle("STRATEGY IMPROVEMENT"),

          GlassCard(
            child: Column(
              children: [
                IdeaTextarea(
                  controller: controller.strategyController,
                  hint: "Improve your business strategy",
                ),

                const SizedBox(height: 12),

                SuggestionBlock(
                  title: "AI Suggestion",
                  suggestion: controller.titleSuggestion.value,
                  reason: controller.titleReason.value,
                  onApply: controller.applyTitleSuggestion,
                )

              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SCORE CARD =================
  Widget _scoreCard() {
    return Center(
      child: GlassCard(
        child: Column(
          children: [
            const Text(
              "AI Evaluation Score",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 10),

            Obx(() => Text(
              "${controller.score.value}/100",
              style: const TextStyle(
                color: Color(0xFF06B6D4),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            )),

            const SizedBox(height: 8),

            const Text(
              "Improve key areas to increase success probability",
              style: TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
