import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter_navigation/models/conversion_type.dart';
import 'package:unit_converter_navigation/services/conversion_service.dart';

void main() {
  group('Length Conversion Tests', () {
    test('1 kilometer to meters = 1000 meters', () {
      final result = ConversionService.convert(
        type: ConversionType.length,
        value: 1.0,
        fromUnitId: 'km',
        toUnitId: 'm',
      );
      expect(result, equals(1000.0));
      expect(ConversionService.formatNumber(result), equals('1000'));
    });

    test('100 centimeters to meters = 1 meter', () {
      final result = ConversionService.convert(
        type: ConversionType.length,
        value: 100.0,
        fromUnitId: 'cm',
        toUnitId: 'm',
      );
      expect(result, closeTo(1.0, 1e-9));
      expect(ConversionService.formatNumber(result), equals('1'));
    });

    test('1 mile to kilometers ≈ 1.609344 kilometers', () {
      final result = ConversionService.convert(
        type: ConversionType.length,
        value: 1.0,
        fromUnitId: 'mi',
        toUnitId: 'km',
      );
      expect(result, closeTo(1.609344, 1e-6));
      expect(ConversionService.formatNumber(result), equals('1.609344'));
    });

    test('1 foot to inches = 12 inches', () {
      final result = ConversionService.convert(
        type: ConversionType.length,
        value: 1.0,
        fromUnitId: 'ft',
        toUnitId: 'in',
      );
      expect(result, closeTo(12.0, 1e-6));
    });

    test('1 yard to feet = 3 feet', () {
      final result = ConversionService.convert(
        type: ConversionType.length,
        value: 1.0,
        fromUnitId: 'yd',
        toUnitId: 'ft',
      );
      expect(result, closeTo(3.0, 1e-6));
    });

    test('Negative length throws ConversionException', () {
      expect(
        () => ConversionService.convert(
          type: ConversionType.length,
          value: -5.0,
          fromUnitId: 'm',
          toUnitId: 'km',
        ),
        throwsA(isA<ConversionException>()),
      );
    });
  });

  group('Weight Conversion Tests', () {
    test('1 kilogram to grams = 1000 grams', () {
      final result = ConversionService.convert(
        type: ConversionType.weight,
        value: 1.0,
        fromUnitId: 'kg',
        toUnitId: 'g',
      );
      expect(result, equals(1000.0));
      expect(ConversionService.formatNumber(result), equals('1000'));
    });

    test('1000 grams to kilograms = 1 kilogram', () {
      final result = ConversionService.convert(
        type: ConversionType.weight,
        value: 1000.0,
        fromUnitId: 'g',
        toUnitId: 'kg',
      );
      expect(result, equals(1.0));
      expect(ConversionService.formatNumber(result), equals('1'));
    });

    test('1 pound to kilograms ≈ 0.45359237 kilograms', () {
      final result = ConversionService.convert(
        type: ConversionType.weight,
        value: 1.0,
        fromUnitId: 'lb',
        toUnitId: 'kg',
      );
      expect(result, closeTo(0.45359237, 1e-8));
      expect(ConversionService.formatNumber(result), equals('0.45359237'));
    });

    test('1 metric ton to kilograms = 1000 kilograms', () {
      final result = ConversionService.convert(
        type: ConversionType.weight,
        value: 1.0,
        fromUnitId: 't',
        toUnitId: 'kg',
      );
      expect(result, equals(1000.0));
    });

    test('1 pound to ounces = 16 ounces', () {
      final result = ConversionService.convert(
        type: ConversionType.weight,
        value: 1.0,
        fromUnitId: 'lb',
        toUnitId: 'oz',
      );
      expect(result, closeTo(16.0, 1e-6));
    });

    test('Negative weight throws ConversionException', () {
      expect(
        () => ConversionService.convert(
          type: ConversionType.weight,
          value: -10.0,
          fromUnitId: 'kg',
          toUnitId: 'g',
        ),
        throwsA(isA<ConversionException>()),
      );
    });
  });

  group('Temperature Conversion Tests', () {
    test('0°C to Fahrenheit = 32°F', () {
      final result = ConversionService.convert(
        type: ConversionType.temperature,
        value: 0.0,
        fromUnitId: 'celsius',
        toUnitId: 'fahrenheit',
      );
      expect(result, equals(32.0));
      expect(ConversionService.formatNumber(result), equals('32'));
    });

    test('100°C to Fahrenheit = 212°F', () {
      final result = ConversionService.convert(
        type: ConversionType.temperature,
        value: 100.0,
        fromUnitId: 'celsius',
        toUnitId: 'fahrenheit',
      );
      expect(result, equals(212.0));
      expect(ConversionService.formatNumber(result), equals('212'));
    });

    test('0°C to Kelvin = 273.15 K', () {
      final result = ConversionService.convert(
        type: ConversionType.temperature,
        value: 0.0,
        fromUnitId: 'celsius',
        toUnitId: 'kelvin',
      );
      expect(result, equals(273.15));
      expect(ConversionService.formatNumber(result), equals('273.15'));
    });

    test('32°F to Celsius = 0°C', () {
      final result = ConversionService.convert(
        type: ConversionType.temperature,
        value: 32.0,
        fromUnitId: 'fahrenheit',
        toUnitId: 'celsius',
      );
      expect(result, equals(0.0));
      expect(ConversionService.formatNumber(result), equals('0'));
    });

    test('273.15 K to Celsius = 0°C', () {
      final result = ConversionService.convert(
        type: ConversionType.temperature,
        value: 273.15,
        fromUnitId: 'kelvin',
        toUnitId: 'celsius',
      );
      expect(result, equals(0.0));
      expect(ConversionService.formatNumber(result), equals('0'));
    });

    test('Fahrenheit to Kelvin (32°F = 273.15 K)', () {
      final result = ConversionService.convert(
        type: ConversionType.temperature,
        value: 32.0,
        fromUnitId: 'fahrenheit',
        toUnitId: 'kelvin',
      );
      expect(result, closeTo(273.15, 1e-6));
    });

    test('Kelvin to Fahrenheit (373.15 K = 212°F)', () {
      final result = ConversionService.convert(
        type: ConversionType.temperature,
        value: 373.15,
        fromUnitId: 'kelvin',
        toUnitId: 'fahrenheit',
      );
      expect(result, closeTo(212.0, 1e-6));
    });

    test('-40°C to Fahrenheit = -40°F (cross point)', () {
      final result = ConversionService.convert(
        type: ConversionType.temperature,
        value: -40.0,
        fromUnitId: 'celsius',
        toUnitId: 'fahrenheit',
      );
      expect(result, equals(-40.0));
    });

    test('Invalid temperatures below absolute zero throw ConversionException', () {
      // Below -273.15 C
      expect(
        () => ConversionService.convert(
          type: ConversionType.temperature,
          value: -273.16,
          fromUnitId: 'celsius',
          toUnitId: 'fahrenheit',
        ),
        throwsA(isA<ConversionException>()),
      );

      // Below -459.67 F
      expect(
        () => ConversionService.convert(
          type: ConversionType.temperature,
          value: -460.0,
          fromUnitId: 'fahrenheit',
          toUnitId: 'celsius',
        ),
        throwsA(isA<ConversionException>()),
      );

      // Below 0 K
      expect(
        () => ConversionService.convert(
          type: ConversionType.temperature,
          value: -0.01,
          fromUnitId: 'kelvin',
          toUnitId: 'celsius',
        ),
        throwsA(isA<ConversionException>()),
      );
    });

    test('Exact absolute zero boundary is valid', () {
      // Exact -273.15 C should convert to 0 K
      final kelvin = ConversionService.convert(
        type: ConversionType.temperature,
        value: -273.15,
        fromUnitId: 'celsius',
        toUnitId: 'kelvin',
      );
      expect(kelvin, closeTo(0.0, 1e-6));

      // Exact 0 K should convert to -273.15 C
      final celsius = ConversionService.convert(
        type: ConversionType.temperature,
        value: 0.0,
        fromUnitId: 'kelvin',
        toUnitId: 'celsius',
      );
      expect(celsius, closeTo(-273.15, 1e-6));
    });
  });

  group('Same Unit & Formatting Tests', () {
    test('Same unit returns exact value', () {
      final result = ConversionService.convert(
        type: ConversionType.length,
        value: 42.5,
        fromUnitId: 'm',
        toUnitId: 'm',
      );
      expect(result, equals(42.5));
    });

    test('formatNumber strips unnecessary trailing zeros', () {
      expect(ConversionService.formatNumber(100.0), equals('100'));
      expect(ConversionService.formatNumber(100.5000), equals('100.5'));
      expect(ConversionService.formatNumber(0.0), equals('0'));
      expect(ConversionService.formatNumber(12.3456), equals('12.3456'));
    });

    test('performConversion returns complete ConversionResult', () {
      final res = ConversionService.performConversion(
        type: ConversionType.length,
        value: 5.0,
        fromUnitId: 'km',
        toUnitId: 'm',
      );
      expect(res.inputValue, equals(5.0));
      expect(res.outputValue, equals(5000.0));
      expect(res.formattedInput, equals('5'));
      expect(res.formattedOutput, equals('5000'));
      expect(res.summary, equals('5 km = 5000 m'));
      expect(res.formulaDescription, contains('Multiply'));
    });
  });
}
