import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌌 BACKGROUND
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0B0F19),
            ),
          ),

          // radial glow
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.3),
                    radius: 1.2,
                    colors: [
                      Color(0x334F46E5),
                      Color(0x0006B6D4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // CONTENT
          SafeArea(
            child: Obx(() {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // 🧠 TOP IDENTITY
                    Column(
                      children: const [
                        Icon(Icons.bolt, color: Color(0xFF06B6D4), size: 42),
                        SizedBox(height: 12),
                        Text(
                          "StartupLense",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Validate your ideas with AI precision",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // 🧊 GLASS CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Column(
                        children: [

                          // EMAIL FIELD
                          _buildField(
                            label: "Email Address",
                            hint: "Enter your email",
                            icon: Icons.email_outlined,
                            onChanged: controller.setEmail,
                            focused: controller.emailFocus.value,
                            onFocus: controller.setEmailFocus,
                          ),

                          const SizedBox(height: 16),

                          // PASSWORD FIELD
                          _buildPasswordField(),

                          const SizedBox(height: 24),

                          // LOGIN BUTTON
                          _buildLoginButton(),

                          const SizedBox(height: 18),

                          // OR DIVIDER
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

                          // GOOGLE BUTTON
                          _buildGoogleButton(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SIGN UP
                    GestureDetector(
                      onTap: () => Get.toNamed('/signup'),
                      child: RichText(
                        text: const TextSpan(
                          text: "Don’t have an account? ",
                          style: TextStyle(color: Colors.white60),
                          children: [
                            TextSpan(
                              text: "Sign Up",
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
          ),
        ],
      ),
    );
  }

  // ---------- EMAIL FIELD ----------
  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    required bool focused,
    required Function(bool) onFocus,
  }) {
    return Focus(
      onFocusChange: onFocus,
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon,
              color: focused ? const Color(0xFF06B6D4) : Colors.white54),
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

  // ---------- PASSWORD FIELD ----------
  Widget _buildPasswordField() {
    return Focus(
      onFocusChange: controller.setPasswordFocus,
      child: TextField(
        obscureText: controller.isPasswordHidden.value,
        onChanged: controller.setPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Password",
          prefixIcon: Icon(Icons.lock_outline,
              color: controller.passwordFocus.value
                  ? const Color(0xFF06B6D4)
                  : Colors.white54),
          suffixIcon: IconButton(
            onPressed: controller.togglePasswordVisibility,
            icon: Icon(
              controller.isPasswordHidden.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.white54,
            ),
          ),
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
            color: controller.passwordFocus.value
                ? const Color(0xFF06B6D4)
                : Colors.white54,
          ),
        ),
      ),
    );
  }

  // ---------- LOGIN BUTTON ----------
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.login,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: EdgeInsets.zero,
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
                : const Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- GOOGLE BUTTON ----------
  Widget _buildGoogleButton() {
    return GestureDetector(
      onTap: controller.loginWithGoogle,
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
            Text(
              "Continue with Google",
              style: TextStyle(color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}