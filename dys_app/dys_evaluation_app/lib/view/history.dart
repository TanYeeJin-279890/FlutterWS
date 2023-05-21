import 'dart:convert';

import 'package:dys_evaluation_app/view/mainscrn/mainscrn.dart';
import 'package:dys_evaluation_app/view/resultPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../fix.dart';
import '../../models/reg.dart';
import '../constant.dart';
import '../models/evaluateeList.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  final Registration reg;
  const HistoryPage({
    Key? key,
    required this.reg,
  }) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Evaluatee> evaluateeList = <Evaluatee>[];
  List<Evaluatee> markList = <Evaluatee>[];

  late double screenHeight, screenWidth, ctrwidth;
  String titlecenter = "Loading...";
  bool Registered = false;
  String center =
      "Unable to View and Save Evaluatee's Result without login 😞 ";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadEvaluateeList();
    });

    // Check if the user is registered
    if (widget.reg.email != "guest@gmail.com") {
      setState(() {
        Registered = true;
      });
    } else {
      setState(() {
        Registered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var text = GoogleFonts.openSansCondensed(
      color: background, // Set the label text color
      fontSize: 25.0, // Set the label text font size
      fontWeight: FontWeight
          .bold, // Set the label text font weight // Set the label text font style
    );

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
                  padding: const EdgeInsets.only(left: 5, top: 10.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.navigate_before_rounded),
                          iconSize: 35,
                          onPressed: () => {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MainScreen(
                                              reg: widget.reg,
                                            )))
                              }),
                      Text(
                        'History Page',
                        style: GoogleFonts.openSansCondensed(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.5),
                      ),
                    ],
                  ),
                ),
              )
            ],
            backgroundColor: background,
            shadowColor: Colors.transparent,
          ),
        ),
        body: evaluateeList.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Registered
                            ? Text(titlecenter, style: text)
                            : Text(center, style: text)),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Evaluatee List", style: text),
                      ],
                    ),
                  ),
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: (1 / 0.28),
                          children:
                              List.generate(evaluateeList.length, (index) {
                            return InkWell(
                                child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: const BorderSide(
                                      width: 2.0, color: Colors.black)),
                              elevation: 10,
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.all(10),
                              child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    List<String> ttlmarks = [
                                      evaluateeList[index]
                                          .Verbal_marks
                                          .toString(),
                                      evaluateeList[index]
                                          .Social_marks
                                          .toString(),
                                      evaluateeList[index]
                                          .Narrative_marks
                                          .toString(),
                                      evaluateeList[index]
                                          .Spatial_marks
                                          .toString(),
                                      evaluateeList[index]
                                          .Kinesthetic_marks
                                          .toString(),
                                      evaluateeList[index]
                                          .Visual_marks
                                          .toString(),
                                      evaluateeList[index]
                                          .MathSci_marks
                                          .toString(),
                                      evaluateeList[index]
                                          .Musical_marks
                                          .toString(),
                                    ];

                                    List<int> intList = ttlmarks
                                        .map((str) => int.parse(str))
                                        .toList(); // Converts the list of strings to a list of integers
                                    print(intList);

                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ResultPage(
                                                  reg: widget.reg,
                                                  ttlmarks: intList,
                                                  name: evaluateeList[index]
                                                      .evaluatee_name
                                                      .toString(),
                                                  age: evaluateeList[index]
                                                      .age
                                                      .toString(),
                                                )));
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Name: ${evaluateeList[index].evaluatee_name}",
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 3),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 1),
                                                          Text(
                                                            "Age: ${evaluateeList[index].age}",
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ]))
                                          ]))),
                            ));
                          })))
                ])));
  }

  void _loadEvaluateeList() {
    http.post(
        Uri.parse("${CONSTANTS.server}/dys_server/php/load_evaluateeList.php"),
        body: {
          'user_id': widget.reg.id,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        titlecenter = "Timeout Please retry again later";
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      // print(widget.reg.id);
      // print(response.body);

      var data = jsonDecode(response.body);

      print(data);
      if (response.statusCode == 200 && data['status'] == 'success') {
        var extractdata = data['data'];

        if (extractdata['evaluatee'] != null) {
          evaluateeList = <Evaluatee>[];
          extractdata['evaluatee'].forEach((v) {
            evaluateeList.add(Evaluatee.fromJson(v));
          });
          titlecenter = evaluateeList.length.toString();
        } else {
          titlecenter = "Fail to load Evaluatee's Result";
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "Fail to load Evaluatee's Result";
        evaluateeList.clear();
        setState(() {});
      }
    });
  }
}
