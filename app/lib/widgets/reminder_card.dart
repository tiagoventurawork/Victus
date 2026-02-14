import 'package:flutter/material.dart';
import '../config/theme.dart';

class ReminderCard extends StatelessWidget {
  final String message;

  const ReminderCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: VictusTheme.reminderGradient,
        borderRadius: BorderRadius.circular(VictusTheme.radiusLarge),
        boxShadow: VictusTheme.softShadow,
      ),
      child: Column(
        children: [
          const Text(
            'LEMBRETE DO DIA:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: VictusTheme.textDark,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: VictusTheme.bodyMedium.copyWith(
              color: VictusTheme.textDark,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}