import 'package:flutter/material.dart';
import '../models/conversion_type.dart';

/// A reusable dropdown selector for units using [DropdownButtonFormField].
class UnitDropdown extends StatelessWidget {
  final String label;
  final String selectedUnitId;
  final List<ConversionUnit> units;
  final ValueChanged<String?> onChanged;
  final IconData prefixIcon;
  final Color? accentColor;

  const UnitDropdown({
    super.key,
    required this.label,
    required this.selectedUnitId,
    required this.units,
    required this.onChanged,
    required this.prefixIcon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = accentColor ?? colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6.0),
        DropdownButtonFormField<String>(
          key: ValueKey('$label-$selectedUnitId'),
          initialValue: selectedUnitId,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: primaryColor,
          ),
          dropdownColor: colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
          decoration: InputDecoration(
            prefixIcon: Icon(
              prefixIcon,
              color: primaryColor,
              size: 20.0,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 14.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.4),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: BorderSide(
                color: primaryColor,
                width: 2.0,
              ),
            ),
          ),
          items: units.map((ConversionUnit unit) {
            return DropdownMenuItem<String>(
              value: unit.id,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      unit.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      unit.symbol,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
