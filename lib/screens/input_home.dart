import 'package:bmi_calculator/calculator_brain.dart';
import 'package:bmi_calculator/components/bottom_button.dart';
import 'package:bmi_calculator/components/icon_content.dart';
import 'package:bmi_calculator/components/reusable_card.dart';
import 'package:bmi_calculator/components/round_button.dart';
import 'package:bmi_calculator/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Gender {
  male,
  female,
}

class InputHome extends StatefulWidget {
  const InputHome({super.key});

  @override
  State<InputHome> createState() => _InputHomeState();
}

class _InputHomeState extends State<InputHome> {
  Gender? selectedGender;
  int height = 180;
  int weight = 60;
  int age = 15;

  // Function to save the calculation to Firestore
  Future<void> saveCalculationToFirestore(
      String bmiResult, String resultText, String interpretation) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get current timestamp
      Timestamp timestamp = Timestamp.now();

      // Reference to the Firestore collection
      CollectionReference historyCollection =
          FirebaseFirestore.instance.collection('history');

      // Add a new document to the history collection
      await historyCollection.add({
        'userId': user.uid,
        'height': height,
        'weight': weight,
        'age': age,
        'bmiResult': bmiResult,
        'resultText': resultText,
        'interpretation': interpretation,
        'timestamp': timestamp,
      });

      print("Calculation saved to Firestore");
    } else {
      print("No user is logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox.square(
            dimension: 10.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0),
            child: const Text(
              "Please Select your gender",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox.square(
            dimension: 5.0,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                    colour: selectedGender == Gender.male
                        ? DynamicColors.activeCardColor(context)
                        : DynamicColors.inactiveCardColor(context),
                    cardChild: const IconContent(
                      label: "MALE",
                      icon: FontAwesomeIcons.mars,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                    colour: selectedGender == Gender.female
                        ? DynamicColors.activeCardColor(context)
                        : DynamicColors.inactiveCardColor(context),
                    cardChild: const IconContent(
                      icon: FontAwesomeIcons.venus,
                      label: "FEMALE",
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox.square(
            dimension: 5.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0),
            child: const Text(
              "How high are you?",
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0),
            child: const Text(
              "Please select your height on the slider below",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox.square(
            dimension: 5.0,
          ),
          Expanded(
            child: ReusableCard(
              colour: DynamicColors.primaryCardColor(context),
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "HEIGHT",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(height.toString(), style: kNumberTextStyle),
                      Text(
                        "cm",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 30.0),
                      thumbColor: const Color(0xFF000000),
                      activeTrackColor: const Color(0xFFEB1555),
                      inactiveTrackColor: const Color(0xFF8D8E98),
                      overlayColor: const Color(0x29EB1555),
                    ),
                    child: Slider(
                      value: height.toDouble(),
                      min: 100.0,
                      max: 300.0,
                      onChanged: (double newValue) {
                        setState(() {
                          height = newValue.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableCard(
                    colour: DynamicColors.inactiveCardColor(context),
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "WEIGHT",
                          style: labelStyle(context),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  weight--;
                                });
                              },
                            ),
                            SizedBox.square(
                              dimension: 50,
                              child: Center(
                                child: Text(
                                  weight.toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  weight++;
                                });
                              },
                            ),
                          ],
                        ),
                        Text(
                          "kgs",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: DynamicColors.inactiveCardColor(context),
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "AGE",
                          style: labelStyle(context),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  age--;
                                });
                              },
                            ),
                            SizedBox.square(
                              dimension: 50,
                              child: Center(
                                child: Text(
                                  age.toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  age++;
                                });
                              },
                            ),
                          ],
                        ),
                        Text(
                          "yrs",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          BottomButton(
            buttonTitle: "CALCULATE",
            onTap: () {
              CalculatorBrain calc =
                  CalculatorBrain(height: height, weight: weight);

              saveCalculationToFirestore(calc.calculateBMI(), calc.getResult(),
                  calc.getInterpretation());

              Navigator.pushNamed(
                context,
                '/results',
                arguments: {
                  'bmiResult': calc.calculateBMI(),
                  'resultText': calc.getResult(),
                  'interpretation': calc.getInterpretation(),
                },
              );
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return ResultsPage(
              //     bmiResult: calc.calculateBMI(),
              //     resultText: calc.getResult(),
              //     interpretation: calc.getInterpretation(),
              //   );
            },
          ),
        ],
      ),
    );
  }
}
