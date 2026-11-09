import 'package:flutter/material.dart';

/// Represents the unit conversion category.
enum ConversionType {
  length,
  weight,
  temperature,
}

/// Information about an individual measurement unit.
class ConversionUnit {
  final String id;
  final String name;
  final String symbol;

  const ConversionUnit({
    required this.id,
    required this.name,
    required this.symbol,
  });

  /// Display text formatted as "Name (symbol)".
  String get displayName => '$name ($symbol)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversionUnit &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Extension providing metadata and helper attributes for [ConversionType].
extension ConversionTypeExtension on ConversionType {
  /// Category name.
  String get categoryName {
    switch (this) {
      case ConversionType.length:
        return 'Length';
      case ConversionType.weight:
        return 'Weight';
      case ConversionType.temperature:
        return 'Temperature';
    }
  }

  /// Screen title.
  String get screenTitle {
    switch (this) {
      case ConversionType.length:
        return 'Length Converter';
      case ConversionType.weight:
        return 'Weight Converter';
      case ConversionType.temperature:
        return 'Temperature Converter';
    }
  }

  /// Description text for cards.
  String get description {
    switch (this) {
      case ConversionType.length:
        return 'Convert different length measurements.';
      case ConversionType.weight:
        return 'Convert different weight measurements.';
      case ConversionType.temperature:
        return 'Convert temperature units easily.';
    }
  }

  /// Action button label on the category card.
  String get buttonLabel {
    switch (this) {
      case ConversionType.length:
        return 'Convert Length';
      case ConversionType.weight:
        return 'Convert Weight';
      case ConversionType.temperature:
        return 'Convert Temperature';
    }
  }

  /// Primary icon representing the category.
  IconData get icon {
    switch (this) {
      case ConversionType.length:
        return Icons.straighten_rounded;
      case ConversionType.weight:
        return Icons.fitness_center_rounded;
      case ConversionType.temperature:
        return Icons.thermostat_rounded;
    }
  }

  /// Accent color for the category.
  Color get accentColor {
    switch (this) {
      case ConversionType.length:
        return const Color(0xFF1565C0); // Deep Blue
      case ConversionType.weight:
        return const Color(0xFF00897B); // Teal / Emerald
      case ConversionType.temperature:
        return const Color(0xFFE65100); // Deep Orange
    }
  }

  /// Background light tint for cards.
  Color get backgroundTint {
    switch (this) {
      case ConversionType.length:
        return const Color(0xFFE3F2FD);
      case ConversionType.weight:
        return const Color(0xFFE0F2F1);
      case ConversionType.temperature:
        return const Color(0xFFFBE9E7);
    }
  }

  /// List of available units for this conversion type.
  List<ConversionUnit> get units {
    switch (this) {
      case ConversionType.length:
        return const [
          ConversionUnit(id: 'm', name: 'Meter', symbol: 'm'),
          ConversionUnit(id: 'km', name: 'Kilometer', symbol: 'km'),
          ConversionUnit(id: 'cm', name: 'Centimeter', symbol: 'cm'),
          ConversionUnit(id: 'mm', name: 'Millimeter', symbol: 'mm'),
          ConversionUnit(id: 'mi', name: 'Mile', symbol: 'mi'),
          ConversionUnit(id: 'ft', name: 'Foot', symbol: 'ft'),
          ConversionUnit(id: 'in', name: 'Inch', symbol: 'in'),
          ConversionUnit(id: 'yd', name: 'Yard', symbol: 'yd'),
        ];
      case ConversionType.weight:
        return const [
          ConversionUnit(id: 'kg', name: 'Kilogram', symbol: 'kg'),
          ConversionUnit(id: 'g', name: 'Gram', symbol: 'g'),
          ConversionUnit(id: 'mg', name: 'Milligram', symbol: 'mg'),
          ConversionUnit(id: 'lb', name: 'Pound', symbol: 'lb'),
          ConversionUnit(id: 'oz', name: 'Ounce', symbol: 'oz'),
          ConversionUnit(id: 't', name: 'Metric Ton', symbol: 't'),
        ];
      case ConversionType.temperature:
        return const [
          ConversionUnit(id: 'celsius', name: 'Celsius', symbol: '°C'),
          ConversionUnit(id: 'fahrenheit', name: 'Fahrenheit', symbol: '°F'),
          ConversionUnit(id: 'kelvin', name: 'Kelvin', symbol: 'K'),
        ];
    }
  }

  /// Default starting unit ID.
  String get defaultFromUnitId {
    switch (this) {
      case ConversionType.length:
        return 'km';
      case ConversionType.weight:
        return 'kg';
      case ConversionType.temperature:
        return 'celsius';
    }
  }

  /// Default target unit ID.
  String get defaultToUnitId {
    switch (this) {
      case ConversionType.length:
        return 'm';
      case ConversionType.weight:
        return 'g';
      case ConversionType.temperature:
        return 'fahrenheit';
    }
  }
}
