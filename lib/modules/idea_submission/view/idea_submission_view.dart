import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/idea_submission_controller.dart';

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
            fontSize: 18
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
            _buildBottomBar(),
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
          _sectionTitle("IDEA FOUNDATION"),
          _ideaFoundationCard(),

          const SizedBox(height: 20),

          _sectionTitle("MARKET & AUDIENCE DETAILS"),
          _marketCard(),

          const SizedBox(height: 20),

          _sectionTitle("BUSINESS MODEL DETAILS"),
          _businessCard(),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          letterSpacing: 1.2,
        ),
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

  // ================= IDEA FOUNDATION =================
  Widget _ideaFoundationCard() {
    return _card(
      child: Column(
        children: [
          _input(
            controller.titleController,
            "Idea Title",
            "e.g. Eco-friendly Delivery Network",
            icon: Icons.lightbulb_outline,
          ),

          const SizedBox(height: 16),

          _textarea(),

          const SizedBox(height: 10),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "✨ Better descriptions improve AI analysis.",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _textarea() {
    return TextField(
      controller: controller.problemController,
      maxLines: 4,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "What specific problem are you solving?",
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ================= MARKET CARD =================
  Widget _marketCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Target Customers",
              style: TextStyle(color: Color(0xFF22D3EE))),

          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _chip("Students"),
              _chip("Professionals"),
              _chip("Businesses"),
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

          const Text("Target City", style: TextStyle(color: Colors.cyanAccent)),

          const SizedBox(height: 10),

          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedCity.value,
            dropdownColor: const Color(0xFF111827),
            style: const TextStyle(color: Colors.white),

            items: controller.cities
                .map((city) => DropdownMenuItem(
              value: city,
              child: Text(city),
            ))
                .toList(),

            onChanged: (val) => controller.onCityChanged(val!),

            decoration: _dropdownDecoration(),
          )),

          const SizedBox(height: 10),
          Obx(() => controller.showCustomCityField.value
              ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextField(
              onSubmitted: controller.addCustomCity,
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
          )
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

          Row(
            children: ["Product", "Service", "Digital"]
                .map((type) => Expanded(
              child: Obx(() {
                final isActive =
                    controller.businessType.value == type;

                return GestureDetector(
                  onTap: () =>
                      controller.changeBusinessType(type),
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 4),
                    padding:
                    const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF22D3EE)
                          : Colors.white10,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isActive
                              ? Colors.black
                              : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ))
                .toList(),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Estimated Budget",
                style: TextStyle(color: Color(0xFF22D3EE)),
              ),
              Obx(() => Text(
                "PKR ${controller.budget.value.toInt()}",
                style: const TextStyle(color: Colors.white),
              )),
            ],
          ),

          const SizedBox(height: 10),

          Obx(() => Slider(
            value: controller.budget.value,
            min: 10000,
            max: 1000000,
            onChanged: controller.updateBudget,
          )),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Low", style: TextStyle(color: Colors.white38)),
              Text("High", style: TextStyle(color: Colors.white38)),
            ],
          ),
        ],
      ),
    );
  }

  // ================= COMPONENTS =================
  Widget _chip(String label) {
    return Obx(() {
      final isSelected = controller.selectedCustomers.contains(label);

      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => controller.toggleCustomer(label),
        selectedColor: Colors.green,
        backgroundColor: Colors.white10,
      );
    });
  }

  Widget _segment(String label) {
    return Expanded(
      child: Obx(() {
        final active = controller.businessType.value == label;

        return GestureDetector(
          onTap: () => controller.changeBusinessType(label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: active ? Colors.cyan : Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(label),
            ),
          ),
        );
      }),
    );
  }

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

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  // ================= BOTTOM BAR =================
  Widget _buildBottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111827), // FIX: no more transparent
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "AI will evaluate market, risk, and strategy",
                style: TextStyle(
                  color: Colors.white70, // FIX visibility
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 12),

              Obx(() => GestureDetector(
                onTapDown: (_) => controller.scale.value = 0.97,
                onTapUp: (_) {
                  controller.scale.value = 1.0;
                  controller.submitIdea();
                },
                onTapCancel: () => controller.scale.value = 1.0,
                child: AnimatedScale(
                  scale: controller.scale.value,
                  duration: const Duration(milliseconds: 100),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4F46E5),
                          Color(0xFF06B6D4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF06B6D4).withOpacity(0.4),
                          blurRadius: 15,
                        )
                      ],
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.analytics_outlined, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Analyze Idea",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ))


            ],
          ),
        ),
      ),
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