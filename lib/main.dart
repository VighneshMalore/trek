import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _display = '0';
  double _num1 = 0;
  double _num2 = 0;
  String _operand = '';
  String _output = '0';

  void _buttonPressed(String buttonText) {
    if (buttonText == 'CLEAR') {
      _output = '0';
      _num1 = 0;
      _num2 = 0;
      _operand = '';
    } else if (buttonText == '+' || buttonText == '-' || buttonText == '×' || buttonText == '÷') {
      _num1 = double.parse(_display);
      _operand = buttonText;
      _output = '0';
    } else if (buttonText == '=') {
      _num2 = double.parse(_display);

      if (_operand == '+') {
        _output = (_num1 + _num2).toString();
      }
      if (_operand == '-') {
        _output = (_num1 - _num2).toString();
      }
      if (_operand == '×') {
        _output = (_num1 * _num2).toString();
      }
      if (_operand == '÷') {
        _output = _num2 != 0 ? (_num1 / _num2).toString() : 'Error';
      }

      _num1 = 0;
      _num2 = 0;
      _operand = '';
    } else {
      if (_output == '0') {
        _output = buttonText;
      } else {
        _output = _output + buttonText;
      }
    }

    setState(() {
      // Format output to remove trailing .0 for clean integers
      if (_output != 'Error' && double.tryParse(_output) != null) {
        double num = double.parse(_output);
        if (num == num.toInt()) {
          _display = num.toInt().toString();
          return;
        }
      }
      _display = _output;
    });
  }

  Widget _buildButton(String buttonText, Color buttonColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(22.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                _display,
                style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(height: 1),
          Column(
            children: [
              Row(children: [
                _buildButton('7', Colors.grey[800]!),
                _buildButton('8', Colors.grey[800]!),
                _buildButton('9', Colors.grey[800]!),
                _buildButton('÷', Colors.orange),
              ]),
              Row(children: [
                _buildButton('4', Colors.grey[800]!),
                _buildButton('5', Colors.grey[800]!),
                _buildButton('6', Colors.grey[800]!),
                _buildButton('×', Colors.orange),
              ]),
              Row(children: [
                _buildButton('1', Colors.grey[800]!),
                _buildButton('2', Colors.grey[800]!),
                _buildButton('3', Colors.grey[800]!),
                _buildButton('-', Colors.orange),
              ]),
              Row(children: [
                _buildButton('CLEAR', Colors.redAccent),
                _buildButton('0', Colors.grey[800]!),
                _buildButton('=', Colors.blueAccent),
                _buildButton('+', Colors.orange),
              ]),
            ],
          )
        ],
      ),
    );
  }
}
