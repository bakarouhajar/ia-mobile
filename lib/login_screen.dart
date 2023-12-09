import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ia_pour_le_mobile/HomePage.dart';
import 'package:ia_pour_le_mobile/template/ActivitiesTemplate.dart';

class LoginEcran extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // If authentication is successful, navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print('Error during login: $e');

      // Show a snackbar with the error message
      final snackBar = SnackBar(
        content: Text(
          'Email or password incorrect',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );

      // Show the snackbar at the bottom of the screen
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logoai.png',
              height: 32, // Adjust the height as needed
            ),
            SizedBox(width: 8), // Adjust the spacing between logos and text
            Expanded(
              child: Text(
                'SocHub',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFA16AE8),
        elevation: 0, // Remove the app bar shadow
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height:
                  MediaQuery.of(context).size.height * 0.2, // Reduced height
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Merci de vous connecter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Updated color
                    ),
                  ),
                  SizedBox(height: 16),
                  buildInputRow(emailController),
                  SizedBox(height: 8),
                  buildInputRow(passwordController, isPassword: true),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await _signInWithEmailAndPassword(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF603F8B),
                      padding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32), // Adjusted padding
                    ),
                    child: Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 18, // Adjusted font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputRow(TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      width: double.infinity, // Adjust the width to fill the screen
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: isPassword ? 'Password' : 'Login',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF603F8B)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF603F8B)),
              ),
            ),
            obscureText: isPassword,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
