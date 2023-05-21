// This class handles the Page to display the user's info on the "Edit Profile" Screen
import 'dart:async';
import 'dart:math';
import 'package:dys_evaluation_app/fix.dart';
import 'package:dys_evaluation_app/models/reg.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'editname.dart';
import 'editpassword.dart';
import 'editphone.dart';

class ProfilePage extends StatefulWidget {
  final Registration reg;
  const ProfilePage({Key? key, required this.reg}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  Random random = Random();
  String smileyFace = '\u{1F600}';

  // Refreshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {
      widget.reg.name = _nameController.text;
      widget.reg.email = _emailController.text;
      widget.reg.phone = _phoneController.text;
    });
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) async {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }

  var text = GoogleFonts.openSansCondensed(
      color: Colors.blueAccent, // Set the label text color
      fontSize: 20.0, // Set the label text font size
      fontWeight: FontWeight
          .w600, // Set the label text font weight // Set the label text font style
      letterSpacing: 1);

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.reg.name.toString();
    _phoneController.text = widget.reg.phone.toString();
    _emailController.text = widget.reg.email.toString();

    return Scaffold(
      backgroundColor: neutral,
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 10,
          ),
          Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            color: neutral,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/3997/3997864.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill),
                ),
              ],
            ),
          ),
          Center(
              child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text('My Profile',
                      style: GoogleFonts.openSansCondensed(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5)))),
          const SizedBox(height: 50),
          buildUserInfoDisplay(
              _nameController.text, 'Name', EditNameFormPage(reg: widget.reg)),
          buildUserInfoDisplay(_phoneController.text, 'Phone',
              EditPhoneFormPage(reg: widget.reg)),
          buildUserInfoDisplay(
              "xxxxxxxxxxx", 'Password', EditPasswordFormPage(reg: widget.reg)),
          Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(
                        fontFamily: "roboto",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: background,
                        letterSpacing: 1),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 350,
                    height: 40,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: background,
                      width: 1,
                    ))),
                    child: Row(children: [
                      Expanded(
                          child: Text(widget.reg.email.toString(),
                              textAlign: TextAlign.center, style: text)),
                      Visibility(
                        visible: true,
                        child: IconButton(
                          color: neutral,
                          iconSize: 30.0,
                          icon: const Icon(Icons.keyboard_arrow_right),
                          onPressed: () {},
                        ),
                      ),
                    ]),
                  )
                ],
              )),
        ],
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontFamily: "roboto",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: background,
                    letterSpacing: 1),
              ),
              Container(
                  width: 350,
                  height: 50,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: background,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              _updateDetails(editPage);
                            },
                            child: Text(
                              getValue,
                              textAlign: TextAlign.center,
                              style: text,
                            ))),
                    IconButton(
                      color: btn,
                      iconSize: 30.0,
                      onPressed: () {
                        _updateDetails(editPage);
                      },
                      icon: const Icon(Icons.keyboard_arrow_right),
                    ),
                  ]))
            ],
          ));

  _updateDetails(Widget editPage) {
    if (widget.reg.email == "guest@gmail.com") {
      Fluttertoast.showToast(
          msg: "Please login/register to edit",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          fontSize: 18.0);
      return;
    } else {
      navigateSecondPage(editPage);
    }
  }
}
