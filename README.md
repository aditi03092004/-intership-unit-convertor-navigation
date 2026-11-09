# Unit Converter with Navigation

A modern, production-grade Flutter application built for accurate, fast multi-category unit conversions. Designed following **Material 3** principles and clean architecture, this application demonstrates dynamic state management, multi-screen navigation using Flutter's native Navigator, decoupled business logic, and automated test coverage.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Internship Project Objective](#-internship-project-objective)
- [Key Features](#-key-features)
- [Supported Conversion Categories & Units](#-supported-conversion-categories--units)
  - [1. Length Converter](#1-length-converter)
  - [2. Weight Converter](#2-weight-converter)
  - [3. Temperature Converter](#3-temperature-converter)
- [Mathematical Formulas & Precision Handling](#-mathematical-formulas--precision-handling)
- [Architecture & Folder Structure](#-architecture--folder-structure)
- [Navigation Workflow](#-navigation-workflow)
- [Screenshots & UI Showcase](#-screenshots--ui-showcase)
- [Technologies & Packages](#-technologies--packages)
- [Installation & Getting Started](#-installation--getting-started)
- [Running the Application](#-running-the-application)
- [Running Automated Unit & Widget Tests](#-running-automated-unit--widget-tests)
- [Author & Submission Details](#-author--submission-details)

---

## 🌟 Overview

The **Unit Converter with Navigation** app provides a responsive interface allowing users to convert measurement units across three key domains: **Length**, **Weight**, and **Temperature**. 

Instead of duplicating converter screens, the application employs a **reusable shared converter screen** (`ConverterScreen`) driven by dynamic configuration models (`ConversionType`) and an isolated calculation service (`ConversionService`).

---

## 🎯 Internship Project Objective

The goal of this internship project is to showcase core Flutter mobile engineering competencies:
1. **State Management**: Using `StatefulWidget` and clean `setState()` workflows for instant UI updates.
2. **Dynamic UI Adaptation**: Constructing a single reusable screen that adjusts titles, icons, unit lists, hints, and formulas dynamically based on the category passed via navigation arguments.
3. **Screen Navigation**: Demonstrating decoupled screen routing with `Navigator.push()` and structured back-navigation via `Navigator.pop()`.
4. **Input Validation & Safety**: Defending against empty inputs, non-numeric strings, negative physical dimensions, and physically impossible temperatures (below absolute zero).
5. **Clean Architecture**: Separating data models, UI components, widgets, and domain math operations into dedicated layers.
6. **Testing & Quality Assurance**: Verifying math formulas and UI behaviors using `flutter test` and `flutter analyze` with 0 warnings.

---

## 🚀 Key Features

- **Material 3 Design**: Professional blue & white color palette, rounded cards (`20.0dp`), subtle elevation, and modern typography.
- **Dynamic Category Screen**: Single shared screen re-used for Length, Weight, and Temperature.
- **Bidirectional Unit Selection**: Two dropdown menus (`DropdownButtonFormField`) for original and target units.
- **One-Tap Unit Swap**: Quickly swap source and target units with immediate re-calculation.
- **Preset Buttons**: Quick-tap chips (`1`, `5`, `10`, `50`, `100`) for rapid testing and conversion.
- **Highlight Result Card**: Prominently shows formatted values, unit symbols, original input reference, and applied formula explanation.
- **Clipboard Integration**: One-click copy of conversion summaries (e.g. `10 km = 10000 m`).
- **Precision Formatting**: Trims trailing zeroes (e.g., `1000` instead of `1000.000000`) and eliminates floating-point roundoff artifacts up to 8 decimal places.
- **Domain Validation**:
  - Restricts negative values for Length and Weight.
  - Enforces absolute zero boundaries for Celsius ($\ge -273.15^\circ\text{C}$), Fahrenheit ($\ge -459.67^\circ\text{F}$), and Kelvin ($\ge 0\text{ K}$).

---

## 📐 Supported Conversion Categories & Units

### 1. Length Converter
Common Base Unit: **Meter (m)**

| Unit | Symbol | Factor to Base (Meters) |
| :--- | :---: | :--- |
| **Meter** | `m` | $1.0\text{ m}$ (Base unit) |
| **Kilometer** | `km` | $1,000.0\text{ m}$ |
| **Centimeter** | `cm` | $0.01\text{ m}$ |
| **Millimeter** | `mm` | $0.001\text{ m}$ |
| **Mile** | `mi` | $1,609.344\text{ m}$ |
| **Foot** | `ft` | $0.3048\text{ m}$ |
| **Inch** | `in` | $0.0254\text{ m}$ |
| **Yard** | `yd` | $0.9144\text{ m}$ |

### 2. Weight Converter
Common Base Unit: **Kilogram (kg)**

| Unit | Symbol | Factor to Base (Kilograms) |
| :--- | :---: | :--- |
| **Kilogram** | `kg` | $1.0\text{ kg}$ (Base unit) |
| **Gram** | `g` | $0.001\text{ kg}$ |
| **Milligram** | `mg` | $0.000001\text{ kg}$ |
| **Pound** | `lb` | $0.45359237\text{ kg}$ |
| **Ounce** | `oz` | $0.028349523125\text{ kg}$ |
| **Metric Ton** | `t` | $1,000.0\text{ kg}$ |

### 3. Temperature Converter
Units: **Celsius (°C)**, **Fahrenheit (°F)**, **Kelvin (K)**

Absolute Zero Thresholds:
- **Celsius**: $\ge -273.15^\circ\text{C}$
- **Fahrenheit**: $\ge -459.67^\circ\text{F}$
- **Kelvin**: $\ge 0\text{ K}$

---

## 🔢 Mathematical Formulas & Precision Handling

### Length & Weight Algorithm
$$\text{BaseValue} = \text{InputValue} \times \text{Factor}_{\text{From}}$$
$$\text{OutputValue} = \frac{\text{BaseValue}}{\text{Factor}_{\text{To}}}$$

### Temperature Formulas
- **Celsius to Fahrenheit**:
  $$F = \left(C \times \frac{9}{5}\right) + 32$$
- **Fahrenheit to Celsius**:
  $$C = (F - 32) \times \frac{5}{9}$$
- **Celsius to Kelvin**:
  $$K = C + 273.15$$
- **Kelvin to Celsius**:
  $$C = K - 273.15$$
- **Fahrenheit to Kelvin**:
  $$K = (F - 32) \times \frac{5}{9} + 273.15$$
- **Kelvin to Fahrenheit**:
  $$F = (K - 273.15) \times \frac{9}{5} + 32$$

---

## 🏗 Architecture & Folder Structure

The application adopts standard Flutter layered architecture:

```
lib/
├── main.dart                      # App entry point, Material 3 theme configuration
├── models/
│   └── conversion_type.dart       # ConversionType enum, ConversionUnit model & metadata
├── screens/
│   ├── home_screen.dart           # Home screen with category cards and navigation
│   └── converter_screen.dart      # Reusable shared converter screen
├── widgets/
│   ├── category_card.dart         # Home screen category card widget
│   ├── unit_dropdown.dart         # Styled DropdownButtonFormField component
│   └── result_card.dart           # Highlighted conversion result card with copy action
└── services/
    └── conversion_service.dart    # Isolated mathematical calculations & validations

test/
├── conversion_service_test.dart   # Unit tests for Length, Weight, Temperature, Limits
└── widget_test.dart               # Widget tests for navigation and UI interaction
```

---

## 🧭 Navigation Workflow

```
       +-----------------------+
       |      HomeScreen       |
       |  - Length Card        |
       |  - Weight Card        |
       |  - Temperature Card   |
       +-----------------------+
                   |
     Navigator.push(context, route)
                   |
                   v
       +------------------------------------+
       |          ConverterScreen           |
       |   (Reusable for all 3 categories)  |
       |  - Title: dynamically updated      |
       |  - Units: dynamically populated    |
       |  - Logic: category-specific math   |
       +------------------------------------+
                   |
     Navigator.pop(context) / Back Arrow
                   |
                   v
       +-----------------------+
       |      HomeScreen       |
       +-----------------------+
```

---

## 📸 Screenshots & UI Showcase

| Home Screen | Length Converter | Temperature Converter |
| :---: | :---: | :---: |
| *(Category cards for Length, Weight & Temperature)* | *(Real-time calculation & unit swap)* | *(Absolute zero validation & formula display)* |

---

## 💻 Technologies & Packages

- **Framework**: Flutter 3.x (Dart 3.x)
- **UI Design System**: Material Design 3
- **Icons**: Flutter Material Icons (`Icons.straighten`, `Icons.fitness_center`, `Icons.thermostat`)
- **Dependencies**: No bloated external libraries; uses pure Flutter SDK and Dart standard libraries (`dart:math`).

---

## ⚙️ Installation & Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (`flutter doctor`)
- Git installed
- Android Studio / IntelliJ IDEA / VS Code with Flutter extension

### Clone Repository
```bash
git clone https://github.com/aditi03092004/-intership-unit-convertor-navigation.git
cd -intership-unit-convertor-navigation
```

### Install Dependencies
```bash
flutter pub get
```

---

## 📱 Running the Application

### Run on Connected Device / Emulator
```bash
flutter run
```

### Run on Windows Desktop
```bash
flutter run -d windows
```

### Run on Chrome (Web)
```bash
flutter run -d chrome
```

---

## 🧪 Running Automated Unit & Widget Tests

Execute all 29 automated unit and widget test cases:

```bash
flutter test
```

### Static Analysis
Verify that all Dart files strictly comply with Flutter lint rules:
```bash
flutter analyze
```

---

## 👩‍💻 Author & Submission Details

- **Author**: Aditi Hundre
- **Repository**: [https://github.com/aditi03092004/-intership-unit-convertor-navigation.git](https://github.com/aditi03092004/-intership-unit-convertor-navigation.git)
- **Project**: Internship Task — Unit Converter with Navigation
