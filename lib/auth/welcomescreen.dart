import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade300, Colors.blue.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset('assets/agro_logo.png', height: 100), // Replace with your logo
            SizedBox(height: 10),
            Text(
              "Agro Market",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 130),
            _buildButton(context, "Login", LoginScreen()),
            _buildButton(context, "Sign Up", SignUpScreen()),
            TextButton(
              onPressed: () {},
              child: Text("Continue as a guest", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text),
      ),
    );
  }
}
