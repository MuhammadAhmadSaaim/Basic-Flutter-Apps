import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> buttons = [
    'C', '+/-', '%', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '-',
    '1', '2', '3', '+',
    '⌫', '0', '.', '='
  ];

  TextEditingController commandController = TextEditingController();
  TextEditingController resultController = TextEditingController();
  String expression = '';
  bool decimal = false;

  void updateTextField(String buttonPressed) {
    setState(() {
      if (buttonPressed == '=') {
        calculateResult();
        decimal = false;
      } else if (buttonPressed == '⌫') {
        deleteLastDigit();
      } else if (buttonPressed == 'C') {
        clearExpression();
        decimal = false;
      } else if (buttonPressed == '+/-') {
        negateNumber();
      } else {
        bool isSymbol = ['+', '-', '*', '/','%'].contains(buttonPressed);
        bool isEmptyExpression = expression.isEmpty;

        if (isSymbol && (isEmptyExpression || expression == '-')) {
          decimal = false;
          return;
        }

        if (isSymbol && expression.isNotEmpty) {
          String lastCharacter = expression[expression.length - 1];
          bool isLastCharacterSymbol = ['+', '-', '*', '/','%'].contains(lastCharacter);
          decimal = false;
          if (isLastCharacterSymbol) {
            deleteLastDigit();
          }
        }

        if (buttonPressed == '0') {
          if (!expression.contains('.') && expression.isEmpty) {
            return;
          }
          String lastCharacter = expression[expression.length - 1];
          bool isLastCharacterSymbol = ['+', '-', '*', '/','%'].contains(lastCharacter);
          if (isLastCharacterSymbol) {
            return;
          }
        }

        if (buttonPressed == '.') {
          if (decimal==true) {
            return;
          }
          if (isEmptyExpression || isSymbol) {
            expression += '0';
          }
          decimal = true;
        }

        expression += buttonPressed;
        commandController.text = expression;
      }
    });
  }

  void calculateResult() {
    String tempExpression = expression;

    Parser p = Parser();
    Expression exp = p.parse(tempExpression);

    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    String result = eval.toString();

    resultController.text = result;
    expression = result;
    commandController.text = expression;
  }

  void clearExpression() {
    expression = '';
    commandController.clear();
    resultController.clear();
  }

  void negateNumber() {
    setState(() {
      if (expression.startsWith('-')) {
        expression = expression.substring(1);
      } else {
        expression = '-' + expression;
      }
      commandController.text = expression;
    });
  }

  void deleteLastDigit() {
    setState(() {
      String lastCharacter = expression[expression.length - 1];
      if(lastCharacter == '.'){
        decimal = false;
      }
      if (expression.isNotEmpty) {
        expression = expression.substring(0, expression.length - 1);
        commandController.text = expression;
      }
    });
  }

  bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          TextField(
            enabled: false,
            controller: commandController,
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.greenAccent, fontSize: 27),
            decoration: InputDecoration(
              hintText: 'Enter an expression',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 27,),
              contentPadding:
                  EdgeInsets.only(top: 50, bottom: 52, right: 20, left: 20),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
          TextField(
            enabled: false,
            controller: resultController,
            style: TextStyle(color: Colors.purple, fontSize: 30,),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 90, bottom: 12, right: 20, left: 20),
              focusedBorder: InputBorder.none,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                String currentButton = buttons[index];
                bool isNumber = isNumeric(currentButton);
                return GestureDetector(
                  onTap: () {
                    updateTextField(currentButton);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10, left: 10, bottom: 15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isNumber ? Colors.blueGrey : Colors.greenAccent,
                    ),
                    child: Center(
                      child: Text(
                        currentButton,
                        style: TextStyle(fontSize: 35, color: isNumber ? Colors.white : Colors.purple),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
