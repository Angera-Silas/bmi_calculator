import 'screens/results_page.dart';
import 'package:flutter/material.dart';
import 'package:bmi_calculator/screens/input_page.dart';
import 'package:bmi_calculator/screens/results_page.dart';

void main() => runApp(BMICalculator());

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: InputPage(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/results') {
          final args = settings.arguments as Map<String, String>;

          return MaterialPageRoute(
            builder: (context) {
              return ResultsPage(
                bmiResult: args['bmiResult']!,
                resultText: args['resultText']!,
                interpretation: args['interpretation']!,
              );
            },
          );
        }
        // Default route
        return MaterialPageRoute(builder: (context) => InputPage());
      },
      routes: {
        '/': (context) => InputPage(),
      },
      title: "BMI Calculator",
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0A0E21),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
    );
  }
}
