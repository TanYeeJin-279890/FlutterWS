import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dys_evaluation_app/fix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constant.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passwordVisible = true;
  late double screenHeight,
      screenWidth,
      resWidth; //used to get the device width and height and set up a responsive widget.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    const text = TextStyle(
      color: background, // Set the label text color
      fontSize: 16.0, // Set the label text font size
      fontWeight: FontWeight
          .bold, // Set the label text font weight // Set the label text font style
    );

    var colorizeTextStyle = GoogleFonts.openSansCondensed(
        color: background,
        fontSize: 40,
        fontWeight: FontWeight.w900,
        letterSpacing: 3);

    return Scaffold(
        backgroundColor: neutral,
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              //backgroundcolor: Colors.amber,
              child: SizedBox(
                width: resWidth,
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const SizedBox(height: 50),
                    Image.network(
                        "https://cdn-icons-png.flaticon.com/512/3997/3997864.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill),
                    const SizedBox(height: 30),
                    AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'WELCOME',
                          textStyle: colorizeTextStyle,
                          colors: colorizeColors,
                        ),
                        ColorizeAnimatedText(
                          'NEW',
                          textStyle: colorizeTextStyle,
                          colors: colorizeColors,
                        ),
                        ColorizeAnimatedText(
                          'USER',
                          textStyle: colorizeTextStyle,
                          colors: colorizeColors,
                        ),
                      ],
                      isRepeatingAnimation: true,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _nameController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),
                            labelText: 'Enter your Name',
                            labelStyle: text,
                            prefixIcon: const Icon(Icons.title),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              (value.length < 3)) {
                            return 'Name must be longer than 3';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _emailController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),
                            labelText: 'Enter your Email',
                            labelStyle: text,
                            prefixIcon: const Icon(Icons.title),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill in the email';
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
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
                        controller: _phoneController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),
                            labelText: 'Enter your Phone',
                            labelStyle: text,
                            prefixIcon: const Icon(Icons.title),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        obscureText: _passwordVisible,
                        textInputAction: TextInputAction.next,
                        controller: _passwordController,
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
                            contentPadding: const EdgeInsets.all(10.0),
                            labelText: 'Enter your password',
                            labelStyle: text,
                            prefixIcon: const Icon(Icons.title),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid password';
                          }
                          //add validator for the password pattern
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        obscureText: _passwordVisible,
                        textInputAction: TextInputAction.next,
                        controller: _repasswordController,
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
                            contentPadding: const EdgeInsets.all(10.0),
                            labelText: 'Please re-enter your password',
                            labelStyle: text,
                            prefixIcon: const Icon(Icons.title),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        validator: (value) {
                          String password = _passwordController.text;
                          if (value == null || value.isEmpty) {
                            return 'Please re-enter your password';
                          }
                          if (value != password) {
                            return "Re-entered password not match.";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ))),
                        onPressed: _checkUser,
                        child: const Text("Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      child: const Text("Done Registered? Click Me!",
                          style: TextStyle(
                              color: btn,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginPage()));
                      },
                    ),
                  ]),
                ),
              )),
        ));
  }

  void _regDialog() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register as new user?",
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
                  _registerUser();
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

  void _registerUser() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _name = _nameController.text;
    String _email = _emailController.text;
    String _phone = _phoneController.text;
    String _password = _passwordController.text;

    http.post(Uri.parse("${CONSTANTS.server}/dys_server/php/registration.php"),
        body: {
          "name": _name,
          "email": _email,
          "phone": _phone,
          "password": _password,
        }).then((response) {
      print(response.body);

      var data = jsonDecode(response.body);
      print("data");
      print(data);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        print("Registration success");
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        print("Registration Failed");
      }
    });
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
            msg: "You have been registered successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        print("send message success");
      } else {
        _regDialog();
        print("non registered user");
      }
    });
  }
}
