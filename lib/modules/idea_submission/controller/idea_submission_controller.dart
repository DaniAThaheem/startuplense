import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IdeaSubmissionController extends GetxController {
  // TEXT CONTROLLERS
  final titleController = TextEditingController();
  final problemController = TextEditingController();
  final customCustomerController = TextEditingController();

  // STATE
  var selectedCustomers = <String>[].obs;
  var showCustomField = false.obs;

  var selectedCity = "Lahore".obs;

  var businessType = "Digital".obs;

  var budget = 50000.0.obs;

  var isAnalyzing = false.obs;


  var cities = ["Lahore", "Karachi", "Islamabad", "Other"].obs;
  var showCustomCityField = false.obs;

  void onCityChanged(String value) {
    if (value == "Other") {
      showCustomCityField.value = true;
    } else {
      selectedCity.value = value;
      showCustomCityField.value = false;
    }
  }

  void addCustomCity(String city) {
    if (!cities.contains(city)) {
      cities.insert(0, city);
    }
    selectedCity.value = city;
    showCustomCityField.value = false;
  }

  // ==========================
  // LOGIC
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

  void changeBusinessType(String type) {
    businessType.value = type;
  }

  void updateBudget(double value) {
    budget.value = value;
  }

  void analyzeIdea() async {
    isAnalyzing.value = true;

    await Future.delayed(const Duration(seconds: 2));

    isAnalyzing.value = false;

    final newIdea = {
      "title": titleController.text,
      "score": 85,
      "status": "Analyzed",
    };

    // RETURN DATA TO DASHBOARD
    Get.back(result: newIdea);
  }
}