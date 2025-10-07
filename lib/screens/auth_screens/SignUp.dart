import 'package:embeded_system_project/screens/auth_screens/signin_screen.dart';
import 'package:embeded_system_project/screens/controller/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets/CustomLabel.dart';
import '../../widgets/widgets/PasswordField.dart';
import '../../widgets/widgets/TextField.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static const String id = "SignUp";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final confirmPass = TextEditingController();
  bool isHeddenPassword = true;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    confirmPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/Mobile login-bro.jpg",
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
        
              CustomLabel(labelText: "Email"),
              SizedBox(height: 8),
              CustomTextField(
                controller: email,
              ),
        
              SizedBox(height: 15),
        
              CustomLabel(labelText: "Password"),
              SizedBox(height: 8),
              PasswordField(isPassword: true, controller: pass),
        
              SizedBox(height: 25),
        
              // Sign Up button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() async {
                      await signup(email, pass);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F55D4),
                    fixedSize: const Size(350, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFD9D9D9),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Color(0xFFD9D9D9),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SigninScreen()));
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2F55D4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }

  Future<void> signup(emailText, passText) async {
    
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailText.text,
          password: passText.text,
        );
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  
 
}
