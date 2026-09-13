import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Mirrors app/about/page.jsx.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About YumTreat')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.ink950, borderRadius: BorderRadius.circular(28)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good food,\nhonestly made.', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, height: 1.2)),
                SizedBox(height: 10),
                Text(
                  "YumTreat started as a small kitchen with one goal: get great food to people fast, without cutting corners on ingredients.",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Our story', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink950)),
          const SizedBox(height: 8),
          const Text(
            "We source fresh ingredients daily, cook in small batches, and get orders out the door as quickly as we can while they're hot. Every dish on the menu is something we'd happily serve our own families.",
            style: TextStyle(color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 20),
          const Text('What we care about', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink950)),
          const SizedBox(height: 10),
          const _ValueRow(icon: Icons.eco_outlined, title: 'Fresh ingredients', body: 'Sourced daily, never frozen for long.'),
          const _ValueRow(icon: Icons.bolt_outlined, title: 'Fast delivery', body: 'Hot food, on time, every time.'),
          const _ValueRow(icon: Icons.favorite_outline, title: 'Made with care', body: 'Small batches, real recipes, no shortcuts.'),
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _ValueRow({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.ember50, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.ember600, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                Text(body, style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
