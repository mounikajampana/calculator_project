import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalcolatorScreen extends StatefulWidget {
  const CalcolatorScreen({super.key});

  @override
  State<CalcolatorScreen> createState() => _CalcolatorScreenState();
}

class _CalcolatorScreenState extends State<CalcolatorScreen> {
  String Input = "";
  String Output = "0";
  List<String> Buttons = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    'C',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE1EEBC),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Column(
              // MainAxisAlignment is used for align the main axis in row or column
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // This Container is for the input box
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 178, 197, 236),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    Input,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),

                SizedBox(
                  height: 15
                ),

                // This Container is for the output box
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    Output,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),


          // This Expanded will displays the buttons with given ratio 
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10,right: 20),
              child: GridView.builder(
                itemCount: Buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 12,
                  childAspectRatio: 4.5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return CustomButton(Buttons[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomButton(String text) {
    return InkWell(
      splashColor: Color(0xffD4C9BE),
      onTap: () {
        setState(() {
          handleButtons(text);
          // This will go to handleButtons function and gives the output
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: Color(0xffF1EFEC),
          borderRadius: BorderRadius.circular(100),
          // This will decorate the buttons 

        ),

        // It will show the numbers and expressions on the buttons
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void handleButtons(String text) {
    // It will clears all the text in Output and input
    if (text == "AC") {
      Input = "";
      Output = "0";
    } 
    else if (text == "C") 
    {
      // It will clears the value which we entered last
      if (Input.isNotEmpty) {
        Input = Input.substring(0, Input.length - 1);
      }
    } else if (text == "=") {
      Output = Calculate();

      //It will replaces the values with .0 with null
      if (Input.endsWith(".0")) {
        Input = Input.replaceAll(".0", "");
      }
      if (Output.endsWith(".0")) {
        Output = Output.replaceAll(".0", "");
      }
      
    } else {
      // If we enter the expressions it will give the spaces
      if ("+-*/()".contains(text)) {
        Input += " $text ";
      } else {
        Input += text;
      }
    }
  }


  String Calculate() {
  try {
    // creatint to understand math expressions
    ShuntingYardParser parser = ShuntingYardParser();

    //removes spaces and parser understands
    Expression expression = parser.parse(Input.replaceAll(' ', ''));

    // create a model that holds values
    ContextModel context = ContextModel();

    //solving the math problem
    double result = expression.evaluate(EvaluationType.REAL, context);

    // returns the answer in string
    return result.toString();
  } catch (e) {
    // If there is a mistake it will prints the Error
    return "Error";
  }
}
}