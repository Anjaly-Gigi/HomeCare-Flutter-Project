import 'package:clients/components/form_validation.dart';
import 'package:clients/main.dart';
import 'package:clients/screen/clientdashboard.dart';
import 'package:clients/screen/registrationpage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mylogin extends StatefulWidget {
  const Mylogin({super.key});

  @override
  State<Mylogin> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Mylogin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String n = '';
  String p = '';
  final formKey = GlobalKey<FormState>();
  bool _isVisible = true;

  Future<void> login() async {
    try {
      await supabase.auth
          .signInWithPassword(password: password.text, email: email.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClientDashboard(),
        ),
      );
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/ppa.png',
                      height: 200,
                      width: 200,
                    ),
                    Text(
                      'Welcome back',
                      style: GoogleFonts.openSans(
                          fontSize: 40,
                          color: const Color.fromARGB(255, 0, 128, 128),
                          textStyle: TextStyle(
                              letterSpacing: 2, fontWeight: FontWeight.bold)),
                    ),
                    Text('Login to your account',
                        style: GoogleFonts.sourceSans3(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 205, 92, 92))),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300, // Adjust width as needed
                      child: TextFormField(
                        validator: (value) => FormValidation.validateEmail(value),
                        controller: email,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10), // Reduces padding
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 75, 0, 130),
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 75, 0, 130),
                              width: 2,
                            ),
                          ),
                          hintText: "Enter email",
                          labelText: "Email",
                          labelStyle:
                              TextStyle(color: Color.fromARGB(255, 75, 0, 130)),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300, // Adjust width as needed
                      child: TextFormField(
                        validator: (value) =>
                            FormValidation.validatePassword(value),
                        controller: password,
                        obscureText: _isVisible,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10), // Reduces padding
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 75, 0, 130),
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 75, 0, 130),
                              width: 2,
                            ),
                          ),
                          hintText: "Enter Password",
                          labelText: "Password",
                          labelStyle:
                              TextStyle(color: Color.fromARGB(255, 75, 0, 130)),
                          prefixIcon: Icon(Icons.password_sharp),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isVisible = !_isVisible;
                              });
                            },
                            icon: Icon(_isVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 128, 128),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: Text("Log in"),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: "If you do not have an account, ",
                            style: GoogleFonts.lato(
                              // Change 'lato' to any font you want
                              color: Colors.black, // Normal text color
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                  text: "Create Account",
                                  style: GoogleFonts.lato(
                                    color: Color.fromARGB(
                                        255, 24, 56, 111), // Hyperlink color
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration
                                        .underline, // Underline for hyperlink effect
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to the UserRegistration page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Myregister(),
                                        ),
                                      );
                                    })
                            ]),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
