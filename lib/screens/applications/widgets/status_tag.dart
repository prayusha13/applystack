import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusTag extends StatelessWidget {
  final String status;
  const StatusTag({Key? key, required this.status}) : super(key: key);

  Color _getStatusColor() {
    switch (status) {
      case 'applied': return const Color(0xFF2563EB);
      case 'phone_screen': return const Color(0xFF7C3AED);
      case 'interview': return const Color(0xFF059669);
      case 'offer': return const Color(0xFFD97706);
      case 'rejected': return const Color(0xFFDC2626);
      default: return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        // Capitalizes the status text for display, e.g., "phone_screen" -> "Phone Screen"
        status.replaceAll('_', ' ').capitalizeFirst!,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}