import 'package:flutter/material.dart';
import '../models/conversion_type.dart';
import '../widgets/category_card.dart';
import 'converter_screen.dart';

/// The primary Home Screen featuring conversion category selection cards.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Navigates to the shared converter screen for the selected [ConversionType]
  /// using [Navigator.push].
  void _navigateToConverter(BuildContext context, ConversionType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConverterScreen(type: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Unit Converter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'FAST & ACCURATE',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Unit Converter',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Convert measurements quickly and accurately.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 15.0,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8.0),

              // Category Cards
              CategoryCard(
                type: ConversionType.length,
                onTap: () => _navigateToConverter(context, ConversionType.length),
              ),

              CategoryCard(
                type: ConversionType.weight,
                onTap: () => _navigateToConverter(context, ConversionType.weight),
              ),

              CategoryCard(
                type: ConversionType.temperature,
                onTap: () => _navigateToConverter(context, ConversionType.temperature),
              ),

              const SizedBox(height: 16.0),

              // Footer Information
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Center(
                  child: Text(
                    'Multi-Unit Converter • Built with Flutter & Material 3',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
