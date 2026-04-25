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
            icon: const Icon(Icons.settings, color: AppColors.secondaryText),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {

          // ── Full page logout loader ──────────────────────
          if (controller.isLoggingOut.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _profileHeader(),
                const SizedBox(height: 24),
                _analyticsSection(),
                const SizedBox(height: 24),
                _insightCard(),
                const SizedBox(height: 24),
                _quickActions(),
                const SizedBox(height: 24),
                _accountSection(),
                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: controller.logout,
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text(
                      "Log out",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ===================== PROFILE HEADER =====================

  Widget _profileHeader() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _headerSkeleton();
      }

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

            // ── Avatar ──────────────────────────────────────
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF4F46E5),
              backgroundImage: NetworkImage(controller.avatarUrl.value),
              onBackgroundImageError: (_, __) {},
            ),

            const SizedBox(height: 12),

            Text(
              controller.name.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              controller.email.value,
              style: const TextStyle(color: AppColors.secondaryText),
            ),

            const SizedBox(height: 10),

            // ── Dynamic badge ────────────────────────────────
            _badge(controller.badge.value),
          ],
        ),
      );
    });
  }

  Widget _badge(String label) {
    Color color;
    switch (label) {
      case 'TOP PERFORMER': color = Colors.green;    break;
      case 'HIGH ACHIEVER': color = Colors.cyan;     break;
      case 'ACTIVE THINKER':color = Colors.orange;   break;
      default:              color = Colors.white54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _headerSkeleton() {
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _shimmer(width: 80, height: 80, radius: 40),
          const SizedBox(height: 12),
          _shimmer(width: 120, height: 16, radius: 6),
          const SizedBox(height: 8),
          _shimmer(width: 160, height: 12, radius: 6),
        ],
      ),
    );
  }

  // ===================== ANALYTICS =====================

  Widget _analyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Analytics",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isStatsLoading.value) {
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(4, (_) => _statCardSkeleton()),
            );
          }

          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _statCard(Icons.lightbulb,    "TOTAL IDEAS",    controller.totalIdeas.value.toString()),
              _statCard(Icons.star,         "BEST SCORE",     controller.bestScore.value.toString()),
              _statCard(Icons.bar_chart,    "AVG. SCORE",     controller.avgScore.value),
              _statCard(Icons.access_time,  "LAST ACTIVITY",  controller.lastActivity.value),
            ],
          );
        }),
      ],
    );
  }

  Widget _statCard(IconData icon, String label, String value) {
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
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmer(width: 36, height: 36, radius: 10),
          const Spacer(),
          _shimmer(width: 50, height: 24, radius: 6),
          const SizedBox(height: 6),
          _shimmer(width: 80, height: 10, radius: 4),
        ],
      ),
    );
  }

  // ===================== INSIGHT CARD =====================

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
                  '"${controller.insight.value}"',
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

  // ===================== QUICK ACTIONS =====================

  Widget _quickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryText,
          ),
        ),
        const SizedBox(height: 12),
        _actionTile(
          icon:    Icons.visibility,
          title:   "View All Ideas",
          onTap:   controller.goToAllIdeas,
        ),
        _actionTile(
          icon:    Icons.compare,
          title:   "Compare Ideas",
          onTap:   controller.goToCompare,
        ),
        _actionTile(
          icon:    Icons.auto_fix_high,
          title:   "Improve Last Idea",
          onTap:   controller.goToImprove,
        ),
      ],
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  // ===================== ACCOUNT SECTION =====================

  Widget _accountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Account Details",
          style: TextStyle(color: AppColors.secondaryText),
        ),
        const SizedBox(height: 12),
        Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _accountRow("Primary Email", controller.email.value),
              const SizedBox(height: 12),
              const _AccountRow("Linked Service", "Google Account"),
            ],
          ),
        )),
      ],
    );
  }

  Widget _accountRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(color: AppColors.primaryText)),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  // ===================== HELPERS =====================

  Widget _shimmer({
    required double width,
    required double height,
    required double radius,
  }) {
    return _ShimmerBox(width: width, height: height, radius: radius);
  }
}

// ─── Static account row ───────────────────────────────────────
class _AccountRow extends StatelessWidget {
  final String title;
  final String value;
  const _AccountRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.primaryText)),
        Text(value, style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.secondaryText,
        )),
      ],
    );
  }
}

// ─── Shimmer box ──────────────────────────────────────────────
class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
  });

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