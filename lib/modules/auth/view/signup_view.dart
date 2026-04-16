import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
          Container(color: const Color(0xFF0B0F19)),

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [
                    Color(0x224F46E5),
                    Color(0x1106B6D4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Obx(() {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 50),

                    // TOP
                    const Icon(Icons.bolt, color: Color(0xFF06B6D4), size: 40),
                    const SizedBox(height: 10),

                    const Text(
                      "StartupLense",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Turn your ideas into validated opportunities",
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: [
                          _field("Full Name", Icons.person, controller.setName, "name"),
                          const SizedBox(height: 14),

                          _field("Email", Icons.email, controller.setEmail, "email"),
                          const SizedBox(height: 14),

                          _secureField(
                            label: "Password",
                            icon: Icons.lock,
                            isHidden: controller.isPasswordHidden.value,
                            toggle: controller.togglePassword,
                            onChanged: controller.setPassword,
                            keyName: "password",
                          ),
                          const SizedBox(height: 14),

                            _secureField(
                              label: "Confirm Password",
                              icon: Icons.lock,
                              isHidden: controller.isConfirmHidden.value,
                              toggle: controller.toggleConfirm,
                              onChanged: controller.setConfirmPassword,
                              keyName: "confirm",
                            ),
                          const SizedBox(height: 14),

                          _field("University (Optional)", Icons.school,
                              controller.setUniversity, "uni"),

                          const SizedBox(height: 22),

                          _signupButton(),

                          const SizedBox(height: 18),

                          Row(
                            children: const [
                              Expanded(child: Divider(color: Colors.white24)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("OR",
                                    style: TextStyle(color: Colors.white38)),
                              ),
                              Expanded(child: Divider(color: Colors.white24)),
                            ],
                          ),

                          const SizedBox(height: 18),

                          _googleButton(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () => Get.back(),
                      child: RichText(
                        text: const TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.white60),
                          children: [
                            TextSpan(
                              text: "Login",
                              style: TextStyle(
                                color: Color(0xFF06B6D4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _field(String label, IconData icon, Function(String) onChanged, String key) {
    final focused = controller.focusField.value == key;

    return Focus(
      onFocusChange: (v) => controller.setFocus(v ? key : ''),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon,
              color: focused ? const Color(0xFF06B6D4) : Colors.white54),
          filled: true,
          fillColor: const Color(0xFF111827),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF06B6D4)),
          ),
          labelStyle: TextStyle(
            color: focused ? const Color(0xFF06B6D4) : Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _secureField({
    required String label,
    required IconData icon,
    required bool isHidden,
    required VoidCallback toggle,
    required Function(String) onChanged,
    required String keyName,
  }) {
    final focused = controller.focusField.value == keyName;

    return Focus(
      onFocusChange: (v) => controller.setFocus(v ? keyName : ''),
      child: TextField(
        obscureText: isHidden,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,

          // LEFT ICON
          prefixIcon: Icon(
            icon,
            color: focused ? const Color(0xFF06B6D4) : Colors.white54,
          ),

          // RIGHT ICON (EYE)
          suffixIcon: IconButton(
            onPressed: toggle,
            icon: Icon(
              isHidden ? Icons.visibility_off : Icons.visibility,
              color: focused ? const Color(0xFF06B6D4) : Colors.white54,
            ),
          ),

          filled: true,
          fillColor: const Color(0xFF111827),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF06B6D4)),
          ),

          labelStyle: TextStyle(
            color: focused ? const Color(0xFF06B6D4) : Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _signupButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.signup,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          child: Center(
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Create Account"),
          ),
        ),
      ),
    );
  }

  Widget _googleButton() {
    return GestureDetector(
      onTap: controller.signupWithGoogle,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.g_mobiledata, color: Colors.white),
            SizedBox(width: 10),
            Text("Sign up with Google",
                style: TextStyle(color: Colors.white70))
          ],
        ),
      ),
    );
  }
}