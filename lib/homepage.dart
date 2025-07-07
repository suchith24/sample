import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:project/button.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userQuestion = '';
  String userAnswer = '';

  final List<String> buttons = [
    'c', 'DEL', '%', '/',
    '9', '8', '7', 'x',
    '6', '5', '4', '-',
    '3', '2', '1', '+',
    '0', '.', 'ANS', '='
  ];

  bool isOperator(String x) {
    return ['%', '/', 'x', '-', '+', '='].contains(x);
  }

  void equalPressed() {
    String finalQuestion = userQuestion.replaceAll('x', '*');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      userAnswer = eval.toString();
    } catch (e) {
      userAnswer = "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(userQuestion, style: TextStyle(fontSize: 24)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(userAnswer, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index) {
                String button = buttons[index];
                Color? color;
                Color? textColor;

                if (button == 'c') {
                  color = Colors.green;
                  textColor = Colors.white;
                } else if (button == 'DEL') {
                  color = Colors.red;
                  textColor = Colors.white;
                } else if (isOperator(button)) {
                  color = Colors.deepPurple;
                  textColor = Colors.white;
                } else {
                  color = Colors.deepPurple[50];
                  textColor = Colors.deepPurple;
                }

                return MyButton(
                  buttonText: button,
                  buttonColor: color!,
                  textColor: textColor!,
                  onTap: () {
                    setState(() {
                      if (button == 'c') {
                        userQuestion = '';
                        userAnswer = '';
                      } else if (button == 'DEL') {
                        if (userQuestion.isNotEmpty) {
                          userQuestion = userQuestion.substring(0, userQuestion.length - 1);
                        }
                      } else if (button == '=') {
                        equalPressed();
                      } else if (button == 'ANS') {
                        userQuestion += userAnswer;
                      } else {
                        userQuestion += button;
                      }
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
