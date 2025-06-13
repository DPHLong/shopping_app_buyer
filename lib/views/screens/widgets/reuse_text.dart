import 'package:flutter/material.dart';

class ReuseText extends StatelessWidget {
  const ReuseText({super.key, required this.title, this.subtitle = ''});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle.isEmpty
              ? const SizedBox()
              : Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}
