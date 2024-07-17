import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0A0E21)),
        navigationBarTheme:
            const NavigationBarThemeData(backgroundColor: Color(0xFF0A0E21)),
        primaryColor: const Color(0xFF0A0E21),
        scaffoldBackgroundColor: const Color(0xFF0A0E21)),
    home: const TemperatureConversion(),
  ));
}

class TemperatureConversion extends StatefulWidget {
  const TemperatureConversion({super.key});

  @override
  State<TemperatureConversion> createState() => _TemperatureConversionState();
}

class _TemperatureConversionState extends State<TemperatureConversion> {
  String _unitType = '°Celcius';
  final List<String> _units = ['°Celcius', '°Ferneight'];
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

    if (_unitType == '°Celcius') {
      result = input * 9 / 5 + 32;
      setState(() {
        _resultValue = '$input °C = ${result.toStringAsFixed(2)} °F';
        _history.insert(0, _resultValue);
        _saveHistory();
      });
    } else if (_unitType == '°Ferneight') {
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
      // backgroundColor: const Color.fromARGB(255, 156, 34, 34),
      appBar: AppBar(
        title: const Text(
          'Temperature Converter',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.teal,
        elevation: 0.0,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).popUntil((route) => route.isFirst);
        //   },
        // ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          disabledBorder: InputBorder.none,
                          hintText: _unitType == '°Celcius' ? "°C" : "°F",
                          labelText: "Enter Temperature in (°C or °F)",
                          suffixIcon: DropdownButton<String>(
                            value: _unitType,
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
                            underline: Container(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (orientation == Orientation.portrait) ...[
                        // ElevatedButton(
                        //   onPressed: _convertTemperature,
                        //   style: ButtonStyle(
                        //     backgroundColor:
                        //         WidgetStateProperty.all<Color>(Colors.red),
                        //     padding: WidgetStateProperty.all<EdgeInsets>(
                        //       const EdgeInsets.symmetric(
                        //           horizontal: 20, vertical: 15),
                        //     ),
                        //     textStyle: WidgetStateProperty.all<TextStyle>(
                        //       const TextStyle(
                        //           fontSize: 18, fontWeight: FontWeight.bold),
                        //     ),
                        //     shape:
                        //         WidgetStateProperty.all<RoundedRectangleBorder>(
                        //       RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //     ),
                        //   ),
                        //   child: const Text(
                        //     'Convert',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // ),

                        const SizedBox(height: 20),
                        Container(
                          color: const Color.fromARGB(47, 12, 159, 227),
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Column(
                            children: [
                              const Text(
                                'Results',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                _resultValue,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _convertTemperature,
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(Colors.teal),
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                ),
                                textStyle: WidgetStateProperty.all<TextStyle>(
                                  const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Calculate',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              color: const Color(0xFF0A0E21),
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              margin: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  const Text(
                                    'Results',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    _resultValue,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 40.0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
          ],
          onTap: (index) {
            if (index == 1) {
              _goToHistory(context);
            }
          },
        ),
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
        title: const Text(
          'Temperature Conversion History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
        child: history.isEmpty
            ? Center(
                child: Text(
                  'No history available',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
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
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
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
