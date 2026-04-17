import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              offset: const Offset(0, 6), // depth
            ),
            const BoxShadow(
              color: Colors.black54,
              blurRadius: 12,
              offset: Offset(0, 4), // shadow base
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: controller.onAddIdea,
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

  // ---------------- APP BAR ----------------
  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // LEFT LOGO (same as login/signup)
        const Icon(
          Icons.bolt, // ⚡ same identity
          color: Color(0xFF06B6D4),
          size: 30,
        ),

        // CENTER TITLE (brand gradient feel)
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

        // RIGHT SIDE
        Row(
          children: [
            Stack(
              children: [
                const Icon(Icons.notifications_none, color: Colors.white70),

                // notification dot
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
            const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF111827),
            ),
          ],
        ),
      ],
    );
  }


  // ---------------- INSIGHTS ----------------
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

        SizedBox(
          height: 144,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _insightCard(Icons.lightbulb, "24", "Total Ideas", "+12%"),
              _insightCard(Icons.bar_chart, "18", "Validated", "+5%"),
              _insightCard(Icons.compare, "6", "Compared", "+3%"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _insightCard(
      IconData icon, String value, String label, String growth) {
    return Container(
      width: Get.width * 0.6, // 👈 2 cards per screen
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
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold),
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

  // ---------------- HERO ----------------
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
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Get AI-powered analysis and market validation in seconds.",
            style: TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 20),

          // CTA Button
          GestureDetector(
            onTap: () async {
              final result = await Get.toNamed(AppRoutes.IDEA_SUBMISSION);

              if (result != null) {
                controller.ideas.insert(0, result);

                Get.snackbar(
                  "Success",
                  "Idea analyzed successfully",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: Container(
              height: 52,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4F46E5),
                    Color(0xFF06B6D4),
                  ],
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
          )
        ],
      ),
    );
  }

  // ---------------- RECENT HEADER ----------------
  Widget _recentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("RECENT EVALUATIONS",
            style: TextStyle(color: Colors.white70)),
        Text("See all", style: TextStyle(color: Colors.cyanAccent)),
      ],
    );
  }

  // ---------------- RECENT LIST ----------------
  Widget _recentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER ROW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Evaluations",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            GestureDetector(
              onTap: controller.onViewAll, // 👈 add this in controller
              child: const Text(
                "See All",
                style: TextStyle(
                  color: Color(0xFF06B6D4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // LIST
        Obx(() {
          return Column(
            children: controller.ideas.map((idea) {
              return _ideaCard(context, idea);
            }).toList(),

          );
        }),
      ],
    );
  }
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
            // TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    idea["title"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // STATUS CHIP
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
                idea["status"],
                style: TextStyle(
                  color: isAnalyzed ? Colors.green : Colors.orange,
                  fontSize: 12,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // BOTTOM ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "2 days ago",
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
                Text(
                  "AI / Startup",
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text("Compare",
                    style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text("Delete",
                    style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }


}