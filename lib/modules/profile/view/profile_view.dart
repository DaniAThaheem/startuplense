import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';
import '../../../core/constants/app_colors.dart';

class ProfileView extends GetView<ProfileController> {


  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
          ).createShader(bounds),
          child: const Text(
            "Profile",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.secondaryText,),
            onPressed: () {},
          )
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 PROFILE HEADER
              _profileHeader(),

              const SizedBox(height: 24),

              /// 🔥 ANALYTICS
              _analyticsSection(),

              const SizedBox(height: 24),

              /// 🔥 AI INSIGHT
              _insightCard(),

              const SizedBox(height: 24),

              /// 🔥 QUICK ACTIONS
              _quickActions(),

              const SizedBox(height: 24),

              /// 🔥 ACCOUNT
              _accountSection(),

              const SizedBox(height: 20),

              /// 🔥 LOGOUT
              Center(
                child: TextButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _profileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4F46E5).withOpacity(0.2),
            const Color(0xFF06B6D4).withOpacity(0.2),
          ],
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                "https://i.pravatar.cc/300"), // temp image
          ),
          const SizedBox(height: 12),

          Obx(() => Text(
            controller.name.value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryText),
          )),

          Obx(() => Text(
            controller.email.value,
            style: const TextStyle(color: AppColors.secondaryText),
          )),

          const SizedBox(height: 10),

          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "TOP PERFORMER",
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
          )
        ],
      ),
    );
  }

  /// ================= ANALYTICS =================
  Widget _analyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Analytics",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),

        const SizedBox(height: 16),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _statCard(Icons.lightbulb, "TOTAL IDEAS",
                controller.totalIdeas),
            _statCard(Icons.star, "BEST SCORE",
                controller.bestScore),
            _statCard(Icons.bar_chart, "AVG. SCORE",
                controller.avgScore),
            _statCard(Icons.access_time, "LAST ACTIVITY",
                controller.lastActivity),
          ],
        )
      ],
    );
  }

  Widget _statCard(IconData icon, String label, Rx value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.accent, size: 22),
          ),

          const Spacer(),

          Obx(() => Text(
            value.value.toString(),
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          )),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= INSIGHT =================
  Widget _insightCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.psychology, color: AppColors.accent, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Your Progress",
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Obx(() => Text(
                  "\"${controller.insight.value}\"",
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= QUICK ACTIONS =================
  Widget _quickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Actions",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryText)),

        const SizedBox(height: 12),

        _actionTile(Icons.visibility, "View All Ideas"),
        _actionTile(Icons.compare, "Compare Ideas"),
        _actionTile(Icons.auto_fix_high, "Improve Last Idea"),
      ],
    );
  }

  Widget _actionTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accent),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const Icon(Icons.arrow_forward_ios,
              size: 14, color: AppColors.secondaryText),
        ],
      ),
    );
  }

  /// ================= ACCOUNT =================
  Widget _accountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Account Details",
            style: TextStyle(color: AppColors.secondaryText)),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: const [
              _accountRow("Primary Email", "alex@lense.ai"),
              SizedBox(height: 12),
              _accountRow("Linked Service", "Google Account"),
            ],
          ),
        )
      ],
    );
  }
}

class _accountRow extends StatelessWidget {
  final String title;
  final String value;

  const _accountRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.primaryText)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.secondaryText)),
      ],
    );
  }
}