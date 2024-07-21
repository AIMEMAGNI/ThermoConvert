# Temperature Conversion App

A simple Flutter application that allows users to convert temperatures between Celsius and Fahrenheit. It includes a history feature to track past conversions.

## Features

- **Temperature Conversion:** Convert temperatures between Celsius and Fahrenheit.
- **History:** Save and view the history of temperature conversions.
- **Responsive Layout:** Adaptable layout for different screen sizes and orientations.
- **Dark Theme:** Consistent dark theme with teal accents.

## Installation

### Prerequisites

- Flutter SDK
- Dart SDK

### Clone the Repository

```bash
git clone https://github.com/AIMEMAGNI/ThermoConvert.git
cd temperature_conversion_app
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```

## Usage

1. **Select Unit:** Use the dropdown menu to choose between Celsius and Fahrenheit.
2. **Enter Temperature:** Input the temperature value in the designated field.
3. **Convert:** Press the "Convert" button to see the result.
4. **View History:** Access the history of conversions by navigating to the history screen.

## Code Overview

### Main File

- **`main.dart`**: Contains the main entry point of the application, including the `TemperatureConversion` and `TemperatureConversionHistory` widgets.

### Temperature Conversion Widget

- **`TemperatureConversion`**: Handles the temperature conversion logic, user input, and displaying results.
- **`_convertTemperature()`**: Performs the conversion based on selected unit and updates the result.
- **`_loadHistory()` and `_saveHistory()`**: Load and save conversion history using `SharedPreferences`.

### Temperature Conversion History Widget

- **`TemperatureConversionHistory`**: Displays the list of past temperature conversions.

