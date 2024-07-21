import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0A0E21)),
      navigationBarTheme: const NavigationBarThemeData(backgroundColor: Color(0xFF0A0E21)),
      primaryColor: const Color(0xFF0A0E21),
      scaffoldBackgroundColor: const Color(0xFF0A0E21),
    ),
    home: const TemperatureConversion(),
  ));
}

class TemperatureConversion extends StatefulWidget {
  const TemperatureConversion({super.key});

  @override
  State<TemperatureConversion> createState() => _TemperatureConversionState();
}

class _TemperatureConversionState extends State<TemperatureConversion> {
  String _unitType = '°Celsius';
  final List<String> _units = ['°Celsius', '°Fahrenheit'];
  final TextEditingController _controller = TextEditingController();
  String _resultValue = '';
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('history') ?? [];
    });
  }

  Future<void> _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('history', _history);
  }

  void _convertTemperature() {
    double input = double.tryParse(_controller.text) ?? 0.0;
    double result;

    if (_unitType == '°Celsius') {
      result = input * 9 / 5 + 32;
      setState(() {
        _resultValue = '$input °C = ${result.toStringAsFixed(2)} °F';
        _history.insert(0, _resultValue);
        _saveHistory();
      });
    } else if (_unitType == '°Fahrenheit') {
      result = (input - 32) * 5 / 9;
      setState(() {
        _resultValue = '$input °F = ${result.toStringAsFixed(2)} °C';
        _history.insert(0, _resultValue);
        _saveHistory();
      });
    }
  }

  void _goToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemperatureConversionHistory(history: _history),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Colors.teal,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              return Container(
                color: const Color(0xFF0A0E21),
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.1,
                  vertical: constraints.maxHeight * 0.05,
                ),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: _unitType,
                        dropdownColor: Colors.teal,
                        items: _units.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _unitType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: _unitType == '°Celsius' ? "Enter Temperature in °C" : "Enter Temperature in °F",
                          labelText: "Temperature",
                          labelStyle: TextStyle(color: Colors.teal),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                        ),
                        style: TextStyle(color: Colors.teal),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _convertTemperature,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: const Text('Convert'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _resultValue,
                        style: const TextStyle(fontSize: 20, color: Colors.teal),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TemperatureConversionHistory extends StatelessWidget {
  final List<String> history;

  const TemperatureConversionHistory({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Conversion History'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: history.isEmpty
            ? Center(
          child: Text('No history available', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
        )
            : ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4.0, offset: Offset(0, 2)),
                ],
              ),
              child: Text(
                history[index],
                style: const TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
