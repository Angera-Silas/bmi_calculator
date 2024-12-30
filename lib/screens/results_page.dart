import 'package:bmi_calculator/components/bottom_button.dart';
import 'package:bmi_calculator/components/reusable_card.dart';
import 'package:bmi_calculator/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage(
      {super.key,
      required this.bmiResult,
      required this.interpretation,
      required this.resultText});

  final String bmiResult;
  final String resultText;
  final String interpretation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReusableCard(
            colour: DynamicColors.inactiveCardColor(context),
            cardChild: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Your BMI is $bmiResult",
                        style: kBMITextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40.0,
                ),
                const CircleAvatar(
                  backgroundColor: Colors.green, // Circular green background
                  radius: 60.0, // Adjust the radius as needed
                  child: Icon(
                    FontAwesomeIcons.check,
                    size: 90.0, // Adjust the icon size
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Text(
                  resultText.toUpperCase(),
                  style: kResultTextStyle,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  interpretation,
                  style: kBodyTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 100.0,
                ),
                BottomButton(
                    buttonTitle: "RE-CALCULATE",
                    onTap: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
