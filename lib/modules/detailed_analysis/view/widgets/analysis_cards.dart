import 'package:flutter/material.dart';
import 'package:startup_lense/core/constants/app_colors.dart';
import 'package:startup_lense/modules/detailed_analysis/controller/detailed_analysis_controller.dart';
import 'package:get/get.dart';
// ================= GLASS CARD =================
Widget glassCard({required Widget child}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.surface.withOpacity(0.85),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withOpacity(0.08)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 10),
        )
      ],
    ),
    child: child,
  );
}

// ================= INDICATOR =================
Widget indicator(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: TextStyle(color: color, fontSize: 12)),
  );
}

// ================= SCORE RING =================
Widget scoreRing(double value) {
  return SizedBox(
    height: 120,
    width: 120,
    child: Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: value / 10,
          strokeWidth: 10,
          backgroundColor: Colors.white10,
          color: AppColors.cyan,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value.toString(),
                style: const TextStyle(fontSize: 28, color: Colors.white)),
            const Text("Strong Score",
                style: TextStyle(color: Colors.white60, fontSize: 12))
          ],
        )
      ],
    ),
  );
}

// ================= MARKET BAR =================
Widget marketBar(String label, double value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white10,
          color: AppColors.cyan,
          minHeight: 8,
        ),
      ),
    ],
  );
}

// ================= SWOT =================
// Widget swotGrid() {
//   return GridView.count(
//     crossAxisCount: 2,
//     shrinkWrap: true,
//     physics: const NeverScrollableScrollPhysics(),
//     crossAxisSpacing: 10,
//     mainAxisSpacing: 10,
//     children: [
//       swotCard("Strengths", AppColors.green),
//       swotCard("Weaknesses", AppColors.red),
//       swotCard("Opportunities", AppColors.cyan),
//       swotCard("Threats", AppColors.orange),
//     ],
//   );
// }

// Widget swotCard(String title, Color color) {
//   return Container(
//     padding: const EdgeInsets.all(12),
//     decoration: BoxDecoration(
//       color: color.withOpacity(0.08),
//       borderRadius: BorderRadius.circular(14),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title,
//             style: TextStyle(color: color, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         const Text("AI generated insight...",
//             style: TextStyle(color: Colors.white60, fontSize: 12))
//       ],
//     ),
//   );
// }

// ================= TIMELINE =================



// Widget coreAlignmentCard() {
//   return Obx(() {
//     final data = DetailedAnalysisController.coreAlignment.value;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF111827),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colors.white.withOpacity(0.05)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           const Text(
//             "Core Alignment",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//
//           const SizedBox(height: 6),
//
//           const Text(
//             "Problem-Solution Fit",
//             style: TextStyle(
//               color: Colors.white60,
//               fontSize: 12,
//             ),
//           ),
//
//           const SizedBox(height: 16),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//
//               _iconBlock(
//                 icon: Icons.report_problem_outlined,
//                 label: "Pain Points",
//                 color: Colors.orange,
//               ),
//
//               Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: AppColors.cyan.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: AppColors.cyan),
//                 ),
//                 child: Text(
//                   data.matchText,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//
//               _iconBlock(
//                 icon: Icons.lightbulb_outline,
//                 label: "Value Prop",
//                 color: AppColors.cyan,
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 16),
//
//           Text(
//             data.description,
//             style: const TextStyle(
//               color: Colors.white70,
//               height: 1.5,
//               fontSize: 13,
//             ),
//           ),
//         ],
//       ),
//     );
//   });
// }
//
//
// Widget _iconBlock({
//   required IconData icon,
//   required String label,
//   required Color color,
// }) {
//   return Column(
//     children: [
//       Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(color: color.withOpacity(0.5)),
//           color: color.withOpacity(0.1),
//         ),
//         child: Icon(icon, color: color, size: 20),
//       ),
//       const SizedBox(height: 6),
//       Text(
//         label,
//         style: const TextStyle(
//           color: Colors.white60,
//           fontSize: 11,
//         ),
//       ),
//     ],
//   );
// }

