import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/idea_repository.dart';

class IdeaSubmissionController extends GetxController {
  // ==========================
  // TEXT CONTROLLERS
  // ==========================
  final titleController = TextEditingController();
  final problemController = TextEditingController();
  final customCustomerController = TextEditingController();
  final customCityController = TextEditingController();

  // ==========================
  // STATE
  // ==========================
  var selectedCustomers = <String>[].obs;
  var showCustomField = false.obs;

  final city = ''.obs;
  var selectedCity = "Lahore".obs;
  var showCustomCityField = false.obs;

  var businessType = "Digital".obs;
  var budget = 50000.0.obs;
  var scale = 1.0.obs;

  var cities = ["Lahore", "Karachi", "Islamabad", "Other"].obs;

  // ==========================
  // CITY LOGIC (FIXED)
  // ==========================
  void onCityChanged(String value) {
    selectedCity.value = value; // ✅ Actually update the selected city

    if (value == "Other") {
      showCustomCityField.value = true; // ✅ Show custom field
    } else {
      showCustomCityField.value = false; // ✅ Hide custom field
      customCityController.clear();     // ✅ Clear any previous custom input
    }
  }

  // ==========================
  // CUSTOMER LOGIC
  // ==========================
  void toggleCustomer(String value) {
    if (value == "Custom") {
      showCustomField.value = !showCustomField.value;
      return;
    }

    if (selectedCustomers.contains(value)) {
      selectedCustomers.remove(value);
    } else {
      selectedCustomers.add(value);
    }
  }

  // ==========================
  // BUSINESS LOGIC
  // ==========================
  void changeBusinessType(String type) {
    businessType.value = type;
  }

  void updateBudget(double value) {
    budget.value = value;
  }

  // ==========================
  // SUBMIT IDEA
  // ==========================
  final IdeaRepository _ideaRepository = IdeaRepository();

  Future<void> submitIdea() async {
    if (titleController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your idea");
      return;
    }

    if (problemController.text.isEmpty) {
      Get.snackbar("Error", "Please describe the problem");
      return;
    }

    // ==========================
    // FINAL CUSTOMERS LIST
    // ==========================
    final customers = [...selectedCustomers];

    if (showCustomField.value && customCustomerController.text.isNotEmpty) {
      final custom = customCustomerController.text.trim();
      if (!customers.contains(custom)) {
        customers.add(custom);
      }
    }

    // ==========================
    // FINAL CITY LOGIC (FIXED)
    // ==========================
    String finalCity;

    if (selectedCity.value == "Other") {
      if (customCityController.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter your city");
        return;
      }
      finalCity = customCityController.text.trim(); // ✅ Use custom city
    } else {
      finalCity = selectedCity.value; // ✅ Use dropdown city
    }

    try {
      final ideaId = await _ideaRepository.submitIdea(
        title: titleController.text.trim(),
        problem: problemController.text.trim(),
        customers: customers,
        city: finalCity,
        businessType: businessType.value,
        budget: budget.value,
        scale: scale.value,
      );

      Get.toNamed(
        '/processing',
        arguments: {
          "ideaId": ideaId,
          "title": titleController.text,
        },
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // ==========================
  // CLEANUP
  // ==========================
  @override
  void onClose() {
    titleController.dispose();
    problemController.dispose();
    customCustomerController.dispose();
    customCityController.dispose();
    super.onClose();
  }
}