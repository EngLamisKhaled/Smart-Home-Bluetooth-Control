import 'package:embeded_system_project/screens/auth_screens/SignUp.dart';
import 'package:embeded_system_project/screens/controller/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helpers/dimintions.dart';
import '../controller/warnning.dart';

int trais = 0;

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController passText = TextEditingController();
  final confirmPass = TextEditingController();
  bool isHeddenPassword = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double spacesHeight(double number) {
      final space = (number / heightRatio) * height;
      return space;
    }

    double spacesWidth(double number) {
      final space = (number / widthRatio) * width;
      return space;
    }

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacesWidth(35),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: spacesHeight(50),
              ),
              SvgPicture.asset(
                "assets/images/login.svg",
                width: spacesWidth(310),
                height: spacesHeight(310),
              ),
              SizedBox(
                height: spacesHeight(26),
              ),
              Text(
                "Login Details",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: spacesHeight(18),
              ),
              Container(
                width: 309,
                height: 62,
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(61, 255, 255, 255),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: const Color(0xFF2F55D4),
                          width: 1,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF2F55D4),
                          width: 1,
                        )),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFF2F55D4),
                    ),
                    hintText: "Email Address",
                    hintStyle: TextStyle(color: const Color(0xFF2F55D4)),
                  ),
                ),
              ),
              SizedBox(
                height: spacesHeight(15),
              ),
              Container(
                width: 309,
                height: 62,
                child: TextField(
                  controller: passText,
                  obscureText: isHeddenPassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(61, 255, 255, 255),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF2F55D4),
                          width: 1,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xFF2F55D4),
                          width: 1,
                        )),
                    prefixIcon: Icon(
                      Icons.key,
                      color: Color(0xFF2F55D4),
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Color(0xFF2F55D4)),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isHeddenPassword = !isHeddenPassword;
                        });
                      },
                      child: Icon(
                        isHeddenPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xFF2F55D4),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: spacesHeight(45),
              ),
              Container(
                width: 314,
                height: 50,
                child: RawMaterialButton(
                  fillColor: const Color(0xFF2F55D4),
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    signin(email, passText);
                    
                      if (trais == 3) {
                        trais=0;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WarningScreen()),
                        );
                      }
                    
                  },
                  child: const Text(
                    "Sign in",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              SizedBox(
                height: spacesHeight(20),
              ),
              Row(
                children: [
                  SizedBox(
                    width: spacesWidth(20),
                  ),
                  Text("Don’t have an account?",
                      style: TextStyle(fontSize: 14, color: Color(0xFF000000))),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color(0xFF2F55D4),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signin(emailAddress, password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailAddress.text,
      password: password.text,
    )
        .then((credential) {
      // Navigate to the HomeScreen if sign-in is successful
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }).catchError((error) {
      // Check if the error is of type FirebaseAuthException
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (error.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else {
          // Handle other Firebase authentication errors
          trais++;
          print('An error occurred: ${error.message}');
          print("trais $trais");
        }
      } else {
        // Handle any other errors
        print('An unexpected error occurred: $error');
      }
    });
  }
}
