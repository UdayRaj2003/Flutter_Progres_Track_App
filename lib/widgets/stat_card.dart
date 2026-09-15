import 'package:flutter/material.dart';

/// A small card that displays a single labeled statistic,
/// e.g. "Today's Study Time" -> "45 min".
///
/// Stateless because it only ever displays data handed to it —
/// it has no internal state of its own to track.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  /// The stat's name, e.g. "Today's Study Time".
  final String label;

  /// The stat's value, already formatted for display, e.g. "45 min".
  final String value;

  /// Optional leading icon for visual context.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
            ],
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}