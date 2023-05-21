import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dys_evaluation_app/fix.dart';
import 'package:dys_evaluation_app/view/mainscrn/mainscrn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
import '../models/reg.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {required List<int> ttlmarks,
      required this.reg,
      required this.name,
      required this.age})
      : ttlmarks = ttlmarks;
  final List<int> ttlmarks;
  final String name;
  final String age;
  final Registration reg;
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool darkMode = false;
  bool useSides = false;
  double numberOfFeatures = 8;
  late List<int> data;
  bool isRegistered = false;
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  void initState() {
    super.initState();

    // Check if the user is registered
    if (widget.reg.email != "guest@gmail.com") {
      setState(() {
        isRegistered = true;
      });
    } else {
      setState(() {
        isRegistered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    data = List.from(widget.ttlmarks.toList());
    const ticks = [0, 5, 10, 15, 20, 25];

    var features = [
      "Verb.",
      "Soc.",
      "Nar.",
      "Spa.",
      "Kine.",
      "Vis.",
      "Math/Sci.",
      "Mus."
    ];

    final List<String> displayCategory = <String>[
      "Verbal: Verb.",
      "Social: Soc.",
      "Narrative: Nar.",
      "Spatial: Spa.",
      "Kinesthetic: Kine.",
      "Visual: Vis.",
      "Mathematical/Scientific: Math/Sci.",
      "Musical: Mus."
    ];

    features = features.sublist(0, numberOfFeatures.floor());
    data = data.sublist(0, numberOfFeatures.floor()).toList();

    //Convert List<int> to List<List<num>>
    List<List<num>> myNumList = [data.map((i) => i).toList()];

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Result Page',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: background,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2000,
              width: 500,
              color: darkMode ? Colors.black : neutral,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            darkMode
                                ? const Text(
                                    'Light mode',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: "roboto",
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Dark mode',
                                    style: TextStyle(
                                        color: background,
                                        fontSize: 15,
                                        fontFamily: "roboto",
                                        fontWeight: FontWeight.bold),
                                  ),
                            Switch(
                              value: darkMode,
                              onChanged: (value) {
                                setState(() {
                                  darkMode = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            useSides
                                ? Text(
                                    'Polygon border',
                                    style: darkMode
                                        ? const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: "roboto",
                                            fontWeight: FontWeight.bold)
                                        : const TextStyle(
                                            color: background,
                                            fontSize: 15,
                                            fontFamily: "roboto",
                                            fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    'Circular border',
                                    style: darkMode
                                        ? const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: "roboto",
                                            fontWeight: FontWeight.bold)
                                        : const TextStyle(
                                            color: background,
                                            fontSize: 15,
                                            fontFamily: "roboto",
                                            fontWeight: FontWeight.bold),
                                  ),
                            Switch(
                              value: useSides,
                              onChanged: (value) {
                                setState(() {
                                  useSides = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Name: ${widget.name}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "roboto",
                              color: background),
                        ),
                      ],
                    ),
                  )),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 1, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Age: ${widget.age}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "roboto",
                              color: background),
                        ),
                      ],
                    ),
                  )),

                  Container(
                    height: 235,
                    width: 360,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 8,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 235,
                            width: 290,
                            child: ListView.builder(
                                itemCount: displayCategory.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              bottom: 5,
                                              top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                displayCategory[index],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "roboto",
                                                    color: background),
                                              ),
                                            ],
                                          ),
                                        ))),
                        SizedBox(
                            height: 235,
                            width: 60,
                            child: ListView.builder(
                                itemCount: widget.ttlmarks.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              bottom: 5,
                                              top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "= ${widget.ttlmarks[index]}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "roboto",
                                                    color: background),
                                              ),
                                            ],
                                          ),
                                        ))),
                      ],
                    ),
                  ),

                  //Set the number of categories being displayed
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Number of features',
                          style: TextStyle(
                              color: darkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Expanded(
                          child: Slider(
                            value: numberOfFeatures,
                            min: 3,
                            max: 8,
                            divisions: 5,
                            activeColor: selectbtn,
                            thumbColor: btn,
                            inactiveColor: btn.withOpacity(0.3),
                            onChanged: (value) {
                              setState(() {
                                numberOfFeatures = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Radar Chart
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 400,
                      width: 400,
                      child: Expanded(
                        child: darkMode
                            ? RadarChart.dark(
                                ticks: ticks,
                                features: features,
                                data: myNumList,
                                reverseAxis: false,
                                useSides: useSides,
                              )
                            : RadarChart.light(
                                ticks: ticks,
                                features: features,
                                data: myNumList,
                                reverseAxis: false,
                                useSides: useSides,
                              ),
                      ),
                    ),
                  ),

                  //Summary
                  SizedBox(
                    child: AnimatedContainer(
                      // Use the properties stored in the State class.
                      width: _width,
                      height: _height,
                      decoration: BoxDecoration(
                        color: _color,
                        borderRadius: _borderRadius,
                      ),
                      // Define how long the animation should take.
                      duration: const Duration(seconds: 1),
                      // Provide an optional curve to make the animation feel smoother.
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),

                  //Summary btn
                  SizedBox(
                    child: ElevatedButton(
                      // ignore: sort_child_properties_last
                      child: Text("Click Me To Summarize",
                          style: GoogleFonts.openSans(
                              color: neutral, // Set the label text color
                              fontSize: 25.0, // Set the label text font size
                              fontWeight: FontWeight
                                  .w700, // Set the label text font weight // Set the label text font style
                              letterSpacing: 1)),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: const BorderSide(color: btn)))),
                      onPressed: () {
                        // Use setState to rebuild the widget with new values.
                        setState(() {
                          // Create a random number generator.
                          final random = Random();

                          // Generate a random width and height.
                          _width = random.nextInt(300).toDouble();
                          _height = random.nextInt(300).toDouble();

                          // Generate a random color.
                          _color = Color.fromRGBO(
                            random.nextInt(256),
                            random.nextInt(256),
                            random.nextInt(256),
                            1,
                          );

                          // Generate a random border radius.
                          _borderRadius = BorderRadius.circular(
                              random.nextInt(100).toDouble());
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            //Button
            Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20.0),
                child: isRegistered
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FloatingActionButton.extended(
                            onPressed: () => {
                              _saveTotalMarks(widget.name, data),
                              Timer(
                                  const Duration(seconds: 5),
                                  () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (content) => MainScreen(
                                                reg: widget.reg,
                                              ))))
                            },
                            icon: const Icon(
                              // <-- Icon
                              Icons.save,
                              size: 24.0,
                            ),
                            label: const Text("Save"),
                            backgroundColor: btn,
                            heroTag: 1,
                          ),
                          FloatingActionButton.extended(
                            onPressed: () => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => MainScreen(
                                            reg: widget.reg,
                                          )))
                            },
                            icon: const Icon(
                              // <-- Icon
                              Icons.navigate_before_rounded,
                              size: 24.0,
                            ),
                            label: const Text("Back"),
                            backgroundColor: btn,
                            heroTag: 2,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FloatingActionButton.extended(
                            onPressed: () => {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MainScreen(
                                            reg: widget.reg,
                                          )))
                            },
                            icon: const Icon(
                              // <-- Icon
                              Icons.restart_alt,
                              size: 24.0,
                            ),
                            label: const Text("Re-Test"),
                            backgroundColor: btn,
                          ),
                        ],
                      )),
          ],
        ),
      ),
    );
  }

  void gatMax() {
    var maxMarks = widget.ttlmarks;
    print(maxMarks);
  }

  void _saveTotalMarks(String name, List<int> data) {
    FocusScope.of(context).requestFocus(FocusNode());
    String verbal = data[0].toString();
    String social = data[1].toString();
    String narrative = data[2].toString();
    String spatial = data[3].toString();
    String kinesthetic = data[4].toString();
    String visual = data[5].toString();
    String mathsci = data[6].toString();
    String musical = data[7].toString();

    http.post(Uri.parse("${CONSTANTS.server}/dys_server/php/saveMarks.php"),
        body: {
          "id": widget.reg.id,
          "name": widget.name,
          "age": widget.age,
          "Verbal_marks": verbal,
          "Social_marks": social,
          "Narrative_marks": narrative,
          "Spatial_marks": spatial,
          "Kinesthetic_marks": kinesthetic,
          "Visual_marks": visual,
          "MathSci_marks": mathsci,
          "Musical_marks": musical,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Save Mark Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        print("Save Mark Success");
      } else {
        Fluttertoast.showToast(
            msg: "Save Mark Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        print("Save Mark Failed");
      }
    });
  }
}
