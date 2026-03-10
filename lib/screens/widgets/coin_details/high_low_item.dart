import 'package:flutter/material.dart';

class HighLowItem extends StatelessWidget {
  final String label;
  final String value;
  const HighLowItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0.8),
        ),
        const SizedBox(height: 2),
        Text(value, style: theme.textTheme.labelLarge),
      ],
    );
  }
}
