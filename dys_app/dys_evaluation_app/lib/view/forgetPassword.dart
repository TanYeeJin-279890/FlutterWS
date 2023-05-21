import 'dart:convert';
import 'package:dys_evaluation_app/fix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constant.dart';
import 'login.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late double screenHeight,
      screenWidth,
      resWidth; //used to get the device width and height and set up a responsive widget.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }

    const text = TextStyle(
      color: background, // Set the label text color
      fontSize: 16.0, // Set the label text font size
      fontWeight: FontWeight
          .bold, // Set the label text font weight // Set the label text font style
    );

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
                                            const LoginPage()))
                              }),
                      Text(
                        'Forgot Password',
                        style: GoogleFonts.openSansCondensed(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3.2),
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
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              //backgroundcolor: Colors.amber,
              child: SizedBox(
                width: resWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _emailController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15.0),
                                labelText: 'Enter your Email',
                                labelStyle: text,
                                prefixIcon: const Icon(Icons.title),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill in the email';
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _passwordVisible,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                contentPadding: const EdgeInsets.all(15.0),
                                labelText: 'Enter a new Password',
                                labelStyle: text,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ))),
                            onPressed: () => {
                              //do something
                              _checkUser(),
                            },
                            child: const Text("Reset Password",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ]),
                ),
              )),
        ));
  }

  void _updatePassword(String password) {
    String newpassword = password;
    http.post(
        Uri.parse("${CONSTANTS.server}/dys_server/php/updatePassViaEmail.php"),
        body: {
          "password": newpassword,
          "email": _emailController.text,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Update success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        print("Update success");
      } else {
        Fluttertoast.showToast(
            msg: "Update Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        print("Update Failed");
      }
    });
  }

  void _resetPasswordDialog() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Reset Password",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _updatePassword(_passwordController.text);
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
  }

  void _checkUser() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _email = _emailController.text;

    http.post(
        Uri.parse("${CONSTANTS.server}/dys_server/php/checkRegistered.php"),
        body: {
          "email": _email,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Existed User",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _resetPasswordDialog();
        print("send message success");
      } else {
        Fluttertoast.showToast(
            msg: "Non existed User, please register as a new user.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        print("non registered user");
      }
    });
  }
}
