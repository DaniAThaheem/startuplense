import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/idea_submission_controller.dart';
import '../widgets/section_title.dart';
import '../widgets/glass_card.dart';
import '../widgets/idea_input.dart';
import '../widgets/idea_textarea.dart';
import '../widgets/idea_chip.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/idea_dropdown.dart';
import '../widgets/business_type_selector.dart';
import '../widgets/budget_slider.dart';

class IdeaSubmissionView extends GetView<IdeaSubmissionController> {
  const IdeaSubmissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(result: null),
        ),

        title: const Text(
          "Submit Startup Idea",
          style: TextStyle(
            color: Color(0xFF22D3EE),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showInfoSheet,
          )
        ],
      ),

      // ================= BODY =================
      body: SafeArea(
        child: Stack(
          children: [
            _buildContent(),
            BottomActionBar(
              scale: controller.scale,
              onTap: controller.submitIdea,
            ),
          ],
        ),
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
          const SectionTitle("IDEA FOUNDATION"),
          GlassCard(
            child: Column(
              children: [
                IdeaInput(
                  controller: controller.titleController,
                  label: "Idea Title",
                  hint: "e.g. Eco-friendly Delivery Network",
                  icon: Icons.lightbulb_outline,
                ),

                const SizedBox(height: 16),

                IdeaTextarea(
                  controller: controller.problemController,
                  hint: "What specific problem are you solving?",
                ),

                const SizedBox(height: 10),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "✨ Better descriptions improve AI analysis.",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const SectionTitle("MARKET & AUDIENCE DETAILS"),
          _marketCard(),

          const SizedBox(height: 20),

          const SectionTitle("BUSINESS MODEL DETAILS"),
          _businessCard(),
        ],
      ),
    );
  }

  // ================= CARD WRAPPER =================
  Widget _card({required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
          )
        ],
      ),
      child: child,
    );
  }

  // ================= MARKET CARD =================
  Widget _marketCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Target Customers",
            style: TextStyle(color: Color(0xFF22D3EE)),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Obx(() => IdeaChip(
                label: "Students",
                selected:
                controller.selectedCustomers.contains("Students"),
                onTap: () => controller.toggleCustomer("Students"),
              )),

              Obx(() => IdeaChip(
                label: "Professionals",
                selected: controller.selectedCustomers
                    .contains("Professionals"),
                onTap: () => controller.toggleCustomer("Professionals"),
              )),

              Obx(() => IdeaChip(
                label: "Businesses",
                selected:
                controller.selectedCustomers.contains("Businesses"),
                onTap: () => controller.toggleCustomer("Businesses"),
              )),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => controller.toggleCustomer("Custom"),
              icon: const Icon(Icons.add, color: Colors.white70),
              label: const Text("Custom"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Obx(() => controller.showCustomField.value
              ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _input(
              controller.customCustomerController,
              "Custom Audience",
              "Enter audience",
            ),
          )
              : const SizedBox()),

          const SizedBox(height: 20),

          const Text(
            "Target City",
            style: TextStyle(color: Colors.cyanAccent),
          ),

          const SizedBox(height: 10),

          // ✅ Dropdown always reflects selectedCity
          Obx(() => IdeaDropdown(
            value: controller.selectedCity.value,
            items: controller.cities,
            onChanged: controller.onCityChanged,
          )),

          // ✅ Custom city field shown only when "Other" is selected
          Obx(() => controller.showCustomCityField.value
              ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextField(
              controller: controller.customCityController, // ✅ Bound to controller
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter your city",
                hintStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          )
              : const SizedBox()),

          const SizedBox(height: 8),

          const Text(
            "Helps AI understand market context.",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ================= BUSINESS CARD =================
  Widget _businessCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Business Type",
            style: TextStyle(color: Color(0xFF22D3EE)),
          ),

          const SizedBox(height: 12),

          Obx(() => BusinessTypeSelector(
            selected: controller.businessType.value,
            onChange: controller.changeBusinessType,
          )),

          const SizedBox(height: 20),

          Obx(() => BudgetSlider(
            value: controller.budget.value,
            onChanged: controller.updateBudget,
          )),
        ],
      ),
    );
  }

  // ================= COMPONENTS =================
  Widget _input(
      TextEditingController controller,
      String label,
      String hint, {
        IconData? icon,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF22D3EE),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white60),
            prefixIcon:
            icon != null ? Icon(icon, color: Colors.white70) : null,
            filled: true,
            fillColor: Colors.white10,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ================= INFO SHEET =================
  void _showInfoSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF111827),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Text(
          "AI analyzes your idea based on market demand, risk, and scalability.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}