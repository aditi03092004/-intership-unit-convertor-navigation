import 'package:flutter/material.dart';
import '../models/conversion_type.dart';

/// An attractive, responsive card displayed on the Home Screen for each conversion category.
class CategoryCard extends StatelessWidget {
  final ConversionType type;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: type.accentColor.withValues(alpha: 0.08),
            blurRadius: 16.0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.0),
          splashColor: type.accentColor.withValues(alpha: 0.12),
          highlightColor: type.accentColor.withValues(alpha: 0.06),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Category Icon with subtle colored badge background
                    Container(
                      width: 56.0,
                      height: 56.0,
                      decoration: BoxDecoration(
                        color: type.backgroundTint,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: type.accentColor.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        type.icon,
                        size: 30.0,
                        color: type.accentColor,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    // Title and Category Label
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type.screenTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: colorScheme.onSurface,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            '${type.units.length} Units Available',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: type.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Forward chevron
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.0,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                const SizedBox(height: 14.0),
                // Description
                Text(
                  type.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 44.0,
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: type.accentColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    icon: Icon(
                      type.icon,
                      size: 18.0,
                    ),
                    label: Text(
                      type.buttonLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
