import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';
import '../../fix.dart';
import '../../models/reg.dart';
import '../login.dart';
import '../register.dart';
import 'question.dart';
import 'package:http/http.dart' as http;

class StartPage extends StatefulWidget {
  final Registration reg;
  const StartPage({Key? key, required this.reg}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late double screenHeight, screenWidth, ctrwidth;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   super.initState();
  //   loadPref();
  // }

  @override
  Widget build(BuildContext context) {
    var text = GoogleFonts.openSansCondensed(
        color: neutral, // Set the label text color
        fontSize: 17.0, // Set the label text font size
        fontWeight: FontWeight
            .w600, // Set the label text font weight // Set the label text font style
        letterSpacing: 2);

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
    }
    return Scaffold(
      backgroundColor: neutral,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          actions: [
            Flexible(
              child: Container(
                alignment: Alignment.topLeft,
                height: 100,
                padding: const EdgeInsets.only(left: 10, top: 10.0),
                child: Text(
                  'Dyslexic Evaluation Questions for Strengths and Weaknesses',
                  style: text,
                ),
              ),
            )
          ],
          backgroundColor: background,
          shadowColor: Colors.transparent,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: ctrwidth,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                            "Before we start, please enter the child's information.",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.openSansCondensed(
                                color: background, // Set the label text color
                                fontSize: 25.0, // Set the label text font size
                                fontWeight: FontWeight
                                    .w900, // Set the label text font weight // Set the label text font style
                                letterSpacing: 2)),
                        const SizedBox(
                          height: 60,
                        ),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              labelText: 'Child Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid name';
                            }
                            bool nameValid =
                                RegExp(r"^[A-Za-z\s]*$").hasMatch(value);

                            if (!nameValid) {
                              return 'Please enter a valid name';
                            }
                            if (value.length < 3) {
                              return 'Please enter a valid name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(
                              labelText: 'Child Age',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid age';
                            }
                            // bool ageValid = RegExp(
                            //         r"^(0?[1-9]|[1-9][0-9]s|[1][1-9][1-9]|100)$")
                            //     .hasMatch(value);

                            // if (!ageValid) {
                            //   return 'Please enter a valid age';
                            // }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: screenWidth,
                          height: 50,
                          child: ElevatedButton(
                            // ignore: sort_child_properties_last
                            child: Text("Start",
                                style: GoogleFonts.openSansCondensed(
                                    color: neutral, // Set the label text color
                                    fontSize:
                                        30.0, // Set the label text font size
                                    fontWeight: FontWeight
                                        .w600, // Set the label text font weight // Set the label text font style
                                    letterSpacing: 2)),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: const BorderSide(
                                            color: Colors.blue)))),
                            //to questionnaire page
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  widget.reg.email != "guest@gmail.com") {
                                _saveEvaluatee(
                                    _nameController.text, _ageController.text);
                                String name = _nameController.text;
                                String age = _ageController.text;
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            QuesScreen(
                                              reg: widget.reg,
                                              age: age,
                                              name: name,
                                            )));
                              } else {
                                //_checkUser();
                                String name = _nameController.text;
                                String age = _ageController.text;
                                _authethicationDialog(age, name);
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          child: const Text("Wanna Login? Click Me!",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontFamily: "roboto",
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const LoginPage()));
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          child: const Text("Not Yet Registered? Click Me!",
                              style: TextStyle(
                                  color: background,
                                  fontSize: 18,
                                  fontFamily: "roboto",
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const RegisterPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _authethicationDialog(String age, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Alert that starting Evaluation Test without Login will be unable to save evaluatee's data.",
            style: TextStyle(),
          ),
          content: const Text("Are your sure to proceed without login?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => QuesScreen(
                        reg: widget.reg,
                        age: age.toString(),
                        name: name.toString())));
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveEvaluatee(String name, String age) {
    FocusScope.of(context).requestFocus(FocusNode());
    String _name = _nameController.text;
    String _age = _ageController.text;

    http.post(Uri.parse("${CONSTANTS.server}/dys_server/php/saveEvaluatee.php"),
        body: {
          "id": widget.reg.id,
          "name": _name,
          "age": _age,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Save Evaluatee Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        print("Save Evaluatee Success");
      } else {
        Fluttertoast.showToast(
            msg: "Save Evaluatee Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        print("Save Evaluatee Failed");
      }
    });
  }
}
