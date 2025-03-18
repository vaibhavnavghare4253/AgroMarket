import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
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
            Text("Welcome, Glad to see you!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            _buildTextField("Email Address"),
            _buildTextField("Password", isPassword: true),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {}, child: Text("Forgot Password?", style: TextStyle(color: Colors.white))),
            ),
            _buildButton("Login"),

            TextButton(
              onPressed: () {},
              child: Text("Don't have an account? Sign Up Now", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {},
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



  Widget _socialButton(String assetPath) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white,
      child: Image.asset(assetPath, height: 30),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class EmailLoginPage extends StatefulWidget {
//   @override
//   _EmailLoginPageState createState() => _EmailLoginPageState();
// }
//
// class _EmailLoginPageState extends State<EmailLoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   void loginUser() async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//       navigateToHome(userCredential.user!.uid);
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   void navigateToHome(String userId) async {
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     if (userDoc.exists) {
//       String role = userDoc['role'];
//       if (role == 'User') {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHomePage()));
//       } else {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShopOwnerHomePage()));
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Email Login')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
//             TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
//             SizedBox(height: 20),
//             ElevatedButton(onPressed: loginUser, child: Text('Login')),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class UserHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('User Home')),
//       body: Center(child: Text('Welcome, User!')),
//     );
//   }
// }
//
// class ShopOwnerHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Shop Owner Home')),
//       body: Center(child: Text('Welcome, Shop Owner!')),
//     );
//   }
// }
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// //
// // class LoginPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Login')),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             ElevatedButton(
// //               onPressed: () {
// //                 Navigator.push(context, MaterialPageRoute(builder: (context) => EmailLoginPage()));
// //               },
// //               child: Text('Login with Email'),
// //             ),
// //             SizedBox(height: 10),
// //             ElevatedButton(
// //               onPressed: () {
// //                 Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneLoginPage()));
// //               },
// //               child: Text('Login with Phone'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class EmailLoginPage extends StatefulWidget {
// //   @override
// //   _EmailLoginPageState createState() => _EmailLoginPageState();
// // }
// //
// // class _EmailLoginPageState extends State<EmailLoginPage> {
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //
// //   void loginUser() async {
// //     try {
// //       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
// //         email: emailController.text.trim(),
// //         password: passwordController.text.trim(),
// //       );
// //       navigateToHome(userCredential.user!.uid);
// //     } catch (e) {
// //       print("Error: $e");
// //     }
// //   }
// //
// //   void navigateToHome(String userId) async {
// //     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
// //     if (userDoc.exists) {
// //       String role = userDoc['role'];
// //       if (role == 'User') {
// //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHomePage()));
// //       } else {
// //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShopOwnerHomePage()));
// //       }
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Email Login')),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
// //             TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
// //             SizedBox(height: 20),
// //             ElevatedButton(onPressed: loginUser, child: Text('Login')),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class PhoneLoginPage extends StatefulWidget {
// //   @override
// //   _PhoneLoginPageState createState() => _PhoneLoginPageState();
// // }
// //
// // class _PhoneLoginPageState extends State<PhoneLoginPage> {
// //   final TextEditingController phoneController = TextEditingController();
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   String verificationId = '';
// //
// //   void sendOTP() async {
// //     await _auth.verifyPhoneNumber(
// //       phoneNumber: '+91${phoneController.text.trim()}',
// //       verificationCompleted: (PhoneAuthCredential credential) async {
// //         await _auth.signInWithCredential(credential);
// //       },
// //       verificationFailed: (FirebaseAuthException e) {
// //         print("Verification Failed: $e");
// //       },
// //       codeSent: (String verId, int? resendToken) {
// //         setState(() {
// //           verificationId = verId;
// //         });
// //         Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerificationPage(verificationId: verificationId)));
// //       },
// //       codeAutoRetrievalTimeout: (String verId) {
// //         setState(() {
// //           verificationId = verId;
// //         });
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Phone Login')),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone Number')),
// //             SizedBox(height: 20),
// //             ElevatedButton(onPressed: sendOTP, child: Text('Send OTP')),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class OTPVerificationPage extends StatefulWidget {
// //   final String verificationId;
// //   OTPVerificationPage({required this.verificationId});
// //
// //   @override
// //   _OTPVerificationPageState createState() => _OTPVerificationPageState();
// // }
// //
// // class _OTPVerificationPageState extends State<OTPVerificationPage> {
// //   final TextEditingController otpController = TextEditingController();
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //
// //   void verifyOTP() async {
// //     try {
// //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
// //         verificationId: widget.verificationId,
// //         smsCode: otpController.text.trim(),
// //       );
// //       UserCredential userCredential = await _auth.signInWithCredential(credential);
// //       navigateToHome(userCredential.user!.uid);
// //     } catch (e) {
// //       print("Error: $e");
// //     }
// //   }
// //
// //   void navigateToHome(String userId) async {
// //     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
// //     if (userDoc.exists) {
// //       String role = userDoc['role'];
// //       if (role == 'User') {
// //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHomePage()));
// //       } else {
// //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShopOwnerHomePage()));
// //       }
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('OTP Verification')),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             TextField(controller: otpController, decoration: InputDecoration(labelText: 'Enter OTP')),
// //             SizedBox(height: 20),
// //             ElevatedButton(onPressed: verifyOTP, child: Text('Verify OTP')),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class UserHomePage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('User Home')),
// //       body: Center(child: Text('Welcome, User!')),
// //     );
// //   }
// // }
// //
// // class ShopOwnerHomePage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Shop Owner Home')),
// //       body: Center(child: Text('Welcome, Shop Owner!')),
// //     );
// //   }
// // }
