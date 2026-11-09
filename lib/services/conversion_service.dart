import '../models/conversion_type.dart';

/// Exception thrown when conversion input fails validation.
class ConversionException implements Exception {
  final String message;
  const ConversionException(this.message);

  @override
  String toString() => message;
}

/// Holds the computed result of a conversion operation.
class ConversionResult {
  final double inputValue;
  final ConversionUnit fromUnit;
  final double outputValue;
  final ConversionUnit toUnit;
  final String formattedInput;
  final String formattedOutput;
  final String formulaDescription;

  const ConversionResult({
    required this.inputValue,
    required this.fromUnit,
    required this.outputValue,
    required this.toUnit,
    required this.formattedInput,
    required this.formattedOutput,
    required this.formulaDescription,
  });

  /// Full conversion summary string, e.g. "1 km = 1000 m".
  String get summary =>
      '$formattedInput ${fromUnit.symbol} = $formattedOutput ${toUnit.symbol}';
}

/// Service class handling all conversion logic, formulas, and validations.
class ConversionService {
  // ---------------------------------------------------------------------------
  // LENGTH FACTORS (Base unit: Meter)
  // ---------------------------------------------------------------------------
  static const Map<String, double> _lengthFactorsToMeter = {
    'm': 1.0,
    'km': 1000.0,
    'cm': 0.01,
    'mm': 0.001,
    'mi': 1609.344,
    'ft': 0.3048,
    'in': 0.0254,
    'yd': 0.9144,
  };

  // ---------------------------------------------------------------------------
  // WEIGHT FACTORS (Base unit: Kilogram)
  // ---------------------------------------------------------------------------
  static const Map<String, double> _weightFactorsToKg = {
    'kg': 1.0,
    'g': 0.001,
    'mg': 0.000001,
    'lb': 0.45359237,
    'oz': 0.028349523125,
    't': 1000.0,
  };

  // ---------------------------------------------------------------------------
  // ABSOLUTE ZERO LIMITS (Temperature)
  // ---------------------------------------------------------------------------
  static const double absoluteZeroCelsius = -273.15;
  static const double absoluteZeroFahrenheit = -459.67;
  static const double absoluteZeroKelvin = 0.0;

  /// Validates the input value for the given [type] and [unitId].
  /// Returns `null` if valid, or a descriptive error message if invalid.
  static String? validateInput({
    required ConversionType type,
    required double? value,
    required String unitId,
  }) {
    if (value == null) {
      return 'Please enter a valid numeric value.';
    }

    if (value.isNaN || value.isInfinite) {
      return 'Please enter a finite number.';
    }

    switch (type) {
      case ConversionType.length:
        if (value < 0) {
          return 'Length measurement cannot be negative.';
        }
        break;

      case ConversionType.weight:
        if (value < 0) {
          return 'Weight measurement cannot be negative.';
        }
        break;

      case ConversionType.temperature:
        switch (unitId) {
          case 'celsius':
            if (value < absoluteZeroCelsius) {
              return 'Temperature cannot be below absolute zero (-273.15 °C).';
            }
            break;
          case 'fahrenheit':
            if (value < absoluteZeroFahrenheit) {
              return 'Temperature cannot be below absolute zero (-459.67 °F).';
            }
            break;
          case 'kelvin':
            if (value < absoluteZeroKelvin) {
              return 'Temperature cannot be below absolute zero (0 K).';
            }
            break;
        }
        break;
    }

    return null;
  }

  /// Converts [value] from [fromUnitId] to [toUnitId] for the given [type].
  /// Throws [ConversionException] on invalid inputs or unknown units.
  static double convert({
    required ConversionType type,
    required double value,
    required String fromUnitId,
    required String toUnitId,
  }) {
    // If source and target are the same, return the value directly
    if (fromUnitId == toUnitId) {
      return value;
    }

    // Validate absolute zero and non-negative constraints
    final validationError = validateInput(
      type: type,
      value: value,
      unitId: fromUnitId,
    );
    if (validationError != null) {
      throw ConversionException(validationError);
    }

    switch (type) {
      case ConversionType.length:
        return _convertLength(value, fromUnitId, toUnitId);

      case ConversionType.weight:
        return _convertWeight(value, fromUnitId, toUnitId);

      case ConversionType.temperature:
        return _convertTemperature(value, fromUnitId, toUnitId);
    }
  }

  /// Performs complete conversion and returns a rich [ConversionResult].
  static ConversionResult performConversion({
    required ConversionType type,
    required double value,
    required String fromUnitId,
    required String toUnitId,
  }) {
    final fromUnit = type.units.firstWhere(
      (u) => u.id == fromUnitId,
      orElse: () => throw ConversionException('Unknown unit: $fromUnitId'),
    );
    final toUnit = type.units.firstWhere(
      (u) => u.id == toUnitId,
      orElse: () => throw ConversionException('Unknown unit: $toUnitId'),
    );

    final result = convert(
      type: type,
      value: value,
      fromUnitId: fromUnitId,
      toUnitId: toUnitId,
    );

    final formula = _getFormulaDescription(
      type: type,
      fromUnit: fromUnit,
      toUnit: toUnit,
    );

    return ConversionResult(
      inputValue: value,
      fromUnit: fromUnit,
      outputValue: result,
      toUnit: toUnit,
      formattedInput: formatNumber(value),
      formattedOutput: formatNumber(result),
      formulaDescription: formula,
    );
  }

  // ---------------------------------------------------------------------------
  // LENGTH CONVERSION LOGIC
  // ---------------------------------------------------------------------------
  static double _convertLength(
    double value,
    String fromUnitId,
    String toUnitId,
  ) {
    final fromFactor = _lengthFactorsToMeter[fromUnitId];
    final toFactor = _lengthFactorsToMeter[toUnitId];

    if (fromFactor == null || toFactor == null) {
      throw ConversionException('Invalid length unit specified.');
    }

    // Convert to base unit (meters), then to target unit
    final meters = value * fromFactor;
    return meters / toFactor;
  }

  // ---------------------------------------------------------------------------
  // WEIGHT CONVERSION LOGIC
  // ---------------------------------------------------------------------------
  static double _convertWeight(
    double value,
    String fromUnitId,
    String toUnitId,
  ) {
    final fromFactor = _weightFactorsToKg[fromUnitId];
    final toFactor = _weightFactorsToKg[toUnitId];

    if (fromFactor == null || toFactor == null) {
      throw ConversionException('Invalid weight unit specified.');
    }

    // Convert to base unit (kilograms), then to target unit
    final kilograms = value * fromFactor;
    return kilograms / toFactor;
  }

  // ---------------------------------------------------------------------------
  // TEMPERATURE CONVERSION LOGIC
  // ---------------------------------------------------------------------------
  static double _convertTemperature(
    double value,
    String fromUnitId,
    String toUnitId,
  ) {
    // 1. Convert source to Celsius
    double celsius;
    switch (fromUnitId) {
      case 'celsius':
        celsius = value;
        break;
      case 'fahrenheit':
        // C = (F - 32) * 5 / 9
        celsius = (value - 32.0) * 5.0 / 9.0;
        break;
      case 'kelvin':
        // C = K - 273.15
        celsius = value - 273.15;
        break;
      default:
        throw ConversionException('Invalid temperature unit: $fromUnitId');
    }

    // 2. Convert Celsius to target unit
    switch (toUnitId) {
      case 'celsius':
        return celsius;
      case 'fahrenheit':
        // F = (C * 9 / 5) + 32
        return (celsius * 9.0 / 5.0) + 32.0;
      case 'kelvin':
        // K = C + 273.15
        return celsius + 273.15;
      default:
        throw ConversionException('Invalid temperature unit: $toUnitId');
    }
  }

  // ---------------------------------------------------------------------------
  // FORMULA EXPLANATION HELPER
  // ---------------------------------------------------------------------------
  static String _getFormulaDescription({
    required ConversionType type,
    required ConversionUnit fromUnit,
    required ConversionUnit toUnit,
  }) {
    if (fromUnit.id == toUnit.id) {
      return 'Identical units selected (1 ${fromUnit.symbol} = 1 ${toUnit.symbol})';
    }

    switch (type) {
      case ConversionType.length:
        final fromFactor = _lengthFactorsToMeter[fromUnit.id]!;
        final toFactor = _lengthFactorsToMeter[toUnit.id]!;
        final ratio = fromFactor / toFactor;
        return 'Multiply the length value by ${formatNumber(ratio)}';

      case ConversionType.weight:
        final fromFactor = _weightFactorsToKg[fromUnit.id]!;
        final toFactor = _weightFactorsToKg[toUnit.id]!;
        final ratio = fromFactor / toFactor;
        return 'Multiply the weight value by ${formatNumber(ratio)}';

      case ConversionType.temperature:
        if (fromUnit.id == 'celsius' && toUnit.id == 'fahrenheit') {
          return 'Formula: (°C × 9/5) + 32 = °F';
        } else if (fromUnit.id == 'fahrenheit' && toUnit.id == 'celsius') {
          return 'Formula: (°F − 32) × 5/9 = °C';
        } else if (fromUnit.id == 'celsius' && toUnit.id == 'kelvin') {
          return 'Formula: °C + 273.15 = K';
        } else if (fromUnit.id == 'kelvin' && toUnit.id == 'celsius') {
          return 'Formula: K − 273.15 = °C';
        } else if (fromUnit.id == 'fahrenheit' && toUnit.id == 'kelvin') {
          return 'Formula: (°F − 32) × 5/9 + 273.15 = K';
        } else if (fromUnit.id == 'kelvin' && toUnit.id == 'fahrenheit') {
          return 'Formula: (K − 273.15) × 9/5 + 32 = °F';
        }
        return 'Direct temperature scale conversion';
    }
  }

  // ---------------------------------------------------------------------------
  // NUMBER FORMATTING (Avoids unnecessary trailing zeros)
  // ---------------------------------------------------------------------------
  /// Formats numbers cleanly without trailing zeros, rounding tiny floating point errors.
  static String formatNumber(double value) {
    if (value.isNaN) return 'NaN';
    if (value.isInfinite) return value.isNegative ? '-Infinity' : 'Infinity';

    // Round to 8 decimal places to eliminate tiny floating-point artifacts like .0000000000000002
    final rounded = double.parse(value.toStringAsFixed(8));

    // If it's an integer value, display as integer
    if (rounded == rounded.truncateToDouble()) {
      return rounded.toInt().toString();
    }

    // Convert to string and trim trailing zeroes and unnecessary decimal point
    String str = rounded.toString();
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0+$'), '');
      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
      }
    }
    return str;
  }
}
