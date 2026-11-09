import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter_navigation/main.dart';
import 'package:unit_converter_navigation/models/conversion_type.dart';
import 'package:unit_converter_navigation/screens/converter_screen.dart';
import 'package:unit_converter_navigation/screens/home_screen.dart';

void main() {
  testWidgets('Home screen displays title, subtitle and three category cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle();

    // Verify App Title and Subtitle
    expect(find.text('Unit Converter'), findsWidgets);
    expect(
      find.text('Convert measurements quickly and accurately.'),
      findsOneWidget,
    );

    // Verify Three Category Cards
    expect(find.text('Length Converter'), findsOneWidget);
    expect(find.text('Convert Length'), findsOneWidget);

    expect(find.text('Weight Converter'), findsOneWidget);
    expect(find.text('Convert Weight'), findsOneWidget);

    expect(find.text('Temperature Converter'), findsOneWidget);
  });

  testWidgets(
      'Tapping Length card navigates to ConverterScreen and back with Navigator.pop',
      (WidgetTester tester) async {
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle();

    // Tap on the Convert Length button
    await tester.tap(find.text('Convert Length'));
    await tester.pumpAndSettle();

    // Verify we are on ConverterScreen for Length
    expect(find.byType(ConverterScreen), findsOneWidget);
    expect(find.text('Length Converter'), findsWidgets);
    expect(find.text('Enter value'), findsOneWidget);
    expect(find.text('FROM UNIT'), findsOneWidget);
    expect(find.text('TO UNIT'), findsOneWidget);
    expect(find.text('CONVERSION RESULT'), findsOneWidget);

    // Verify default conversion 1 km = 1000 m
    expect(find.text('1000'), findsOneWidget);

    // Tap the back button (Navigator.pop)
    await tester.tap(find.byTooltip('Back to Categories'));
    await tester.pumpAndSettle();

    // Verify we returned to HomeScreen
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('ConverterScreen handles invalid inputs and displays error',
      (WidgetTester tester) async {
    // Directly test ConverterScreen with temperature
    await tester.pumpWidget(
      const MaterialApp(
        home: ConverterScreen(type: ConversionType.temperature),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial load (1 C to F = 33.8 F)
    expect(find.text('CONVERSION RESULT'), findsOneWidget);

    // Clear input
    final inputFinder = find.byType(TextField);
    await tester.enterText(inputFinder, '');
    await tester.pumpAndSettle();

    final convertBtn = find.text('Convert Now');
    await tester.ensureVisible(convertBtn);
    await tester.tap(convertBtn);
    await tester.pumpAndSettle();

    expect(find.text('Please enter a value to convert.'), findsOneWidget);

    // Enter temperature below absolute zero: -300 °C
    await tester.enterText(inputFinder, '-300');
    await tester.pumpAndSettle();

    await tester.ensureVisible(convertBtn);
    await tester.tap(convertBtn);
    await tester.pumpAndSettle();

    expect(
      find.text('Temperature cannot be below absolute zero (-273.15 °C).'),
      findsOneWidget,
    );
  });

  testWidgets('ConverterScreen performs weight conversion and swapping',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ConverterScreen(type: ConversionType.weight),
      ),
    );
    await tester.pumpAndSettle();

    // Default weight is 1 kg to g = 1000 g
    expect(find.text('1000'), findsOneWidget);

    // Tap Swap Units button
    final swapBtn = find.text('Swap');
    await tester.ensureVisible(swapBtn);
    await tester.tap(swapBtn);
    await tester.pumpAndSettle();

    // 1 g to kg = 0.001 kg
    expect(find.text('0.001'), findsOneWidget);
  });
}
