import 'package:flutter/material.dart';
import '../models/conversion_type.dart';
import '../services/conversion_service.dart';
import '../widgets/result_card.dart';
import '../widgets/unit_dropdown.dart';

/// Reusable shared converter screen that dynamically adapts to
/// Length, Weight, or Temperature conversions based on [ConversionType].
class ConverterScreen extends StatefulWidget {
  final ConversionType type;

  const ConverterScreen({
    super.key,
    required this.type,
  });

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  late final TextEditingController _inputController;
  late final FocusNode _inputFocusNode;

  late String _fromUnitId;
  late String _toUnitId;

  ConversionResult? _conversionResult;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: '1');
    _inputFocusNode = FocusNode();

    _fromUnitId = widget.type.defaultFromUnitId;
    _toUnitId = widget.type.defaultToUnitId;

    // Perform initial default conversion on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performConversion();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  /// Swaps the [fromUnitId] and [toUnitId] and recalculates the result.
  void _swapUnits() {
    setState(() {
      final temp = _fromUnitId;
      _fromUnitId = _toUnitId;
      _toUnitId = temp;
      _errorMessage = null;
    });
    _performConversion();
  }

  /// Sets quick preset values (e.g. 1, 5, 10, 50, 100)
  void _setPresetValue(String value) {
    _inputController.text = value;
    _inputController.selection = TextSelection.fromPosition(
      TextPosition(offset: value.length),
    );
    _performConversion();
  }

  /// Executes conversion calculation with comprehensive error validation.
  void _performConversion() {
    final rawInput = _inputController.text.trim();

    // 1. Check for empty input
    if (rawInput.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a value to convert.';
        _conversionResult = null;
      });
      return;
    }

    // 2. Parse numeric value
    final parsedValue = double.tryParse(rawInput);
    if (parsedValue == null) {
      setState(() {
        _errorMessage = 'Please enter a valid numeric value.';
        _conversionResult = null;
      });
      return;
    }

    // 3. Validate against domain rules (e.g. absolute zero, non-negative)
    final validationError = ConversionService.validateInput(
      type: widget.type,
      value: parsedValue,
      unitId: _fromUnitId,
    );

    if (validationError != null) {
      setState(() {
        _errorMessage = validationError;
        _conversionResult = null;
      });
      return;
    }

    // 4. Compute conversion
    try {
      final result = ConversionService.performConversion(
        type: widget.type,
        value: parsedValue,
        fromUnitId: _fromUnitId,
        toUnitId: _toUnitId,
      );

      setState(() {
        _conversionResult = result;
        _errorMessage = null;
      });
    } on ConversionException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _conversionResult = null;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'An unexpected error occurred during conversion.';
        _conversionResult = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = widget.type.accentColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type.screenTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Back to Categories',
          onPressed: () {
            // Screen back navigation using Navigator.pop
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset to Defaults',
            onPressed: () {
              setState(() {
                _fromUnitId = widget.type.defaultFromUnitId;
                _toUnitId = widget.type.defaultToUnitId;
                _inputController.text = '1';
                _errorMessage = null;
              });
              _performConversion();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Banner Header
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: widget.type.backgroundTint,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Icon(
                        widget.type.icon,
                        color: accentColor,
                        size: 26.0,
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.type.categoryName,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            widget.type.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),

              // Value Input Card
              Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VALUE TO CONVERT',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _inputController,
                      focusNode: _inputFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      textInputAction: TextInputAction.done,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter value',
                        prefixIcon: Icon(
                          Icons.edit_note_rounded,
                          color: accentColor,
                          size: 24,
                        ),
                        suffixIcon: _inputController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                tooltip: 'Clear input',
                                onPressed: () {
                                  _inputController.clear();
                                  setState(() {
                                    _errorMessage = null;
                                    _conversionResult = null;
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.4),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide(
                            color: accentColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (_) {
                        _performConversion();
                      },
                      onSubmitted: (_) {
                        _performConversion();
                      },
                    ),

                    const SizedBox(height: 12.0),

                    // Quick presets chips
                    Wrap(
                      spacing: 8.0,
                      children: ['1', '5', '10', '50', '100'].map((preset) {
                        return ActionChip(
                          label: Text(preset),
                          labelStyle: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                          backgroundColor: widget.type.backgroundTint,
                          side: BorderSide(
                            color: accentColor.withValues(alpha: 0.3),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          onPressed: () => _setPresetValue(preset),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18.0),

              // Unit Selection Card
              Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    UnitDropdown(
                      label: 'FROM UNIT',
                      selectedUnitId: _fromUnitId,
                      units: widget.type.units,
                      prefixIcon: Icons.arrow_circle_up_rounded,
                      accentColor: accentColor,
                      onChanged: (newUnit) {
                        if (newUnit != null) {
                          setState(() {
                            _fromUnitId = newUnit;
                          });
                          _performConversion();
                        }
                      },
                    ),

                    const SizedBox(height: 10.0),

                    // Swap Button Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Tooltip(
                          message: 'Swap Units',
                          child: OutlinedButton.icon(
                            onPressed: _swapUnits,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: accentColor.withValues(alpha: 0.4)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 6.0,
                              ),
                            ),
                            icon: Icon(
                              Icons.swap_vert_rounded,
                              size: 18.0,
                              color: accentColor,
                            ),
                            label: Text(
                              'Swap',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 10.0),

                    UnitDropdown(
                      label: 'TO UNIT',
                      selectedUnitId: _toUnitId,
                      units: widget.type.units,
                      prefixIcon: Icons.arrow_circle_down_rounded,
                      accentColor: accentColor,
                      onChanged: (newUnit) {
                        if (newUnit != null) {
                          setState(() {
                            _toUnitId = newUnit;
                          });
                          _performConversion();
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),

              // Convert Button
              SizedBox(
                height: 52.0,
                child: ElevatedButton.icon(
                  onPressed: _performConversion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: accentColor.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  icon: const Icon(Icons.calculate_rounded, size: 22.0),
                  label: const Text(
                    'Convert Now',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Error display
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: colorScheme.error.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: colorScheme.error,
                        size: 22.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Result Section
              if (_conversionResult != null) ...[
                ResultCard(
                  result: _conversionResult!,
                  accentColor: accentColor,
                ),
                const SizedBox(height: 16.0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
