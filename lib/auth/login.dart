import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Admin/Admin_home.dart';
import '../screens/home_screen/home_screen.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void loginUser() async {
    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        navigateToHome(user.uid);
      } else {
        showSnackbar("Login failed. Please try again.");
      }
    } catch (e) {
      showSnackbar("Error: ${e.toString()}");
      setState(() => isLoading = false);
    }
  }

  void navigateToHome(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        if (role == "Shop Owner") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPanel()),
          );
        } else if (role == "User") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          showSnackbar("Invalid user role.");
        }
      } else {
        showSnackbar("User data not found!");
      }
    } catch (e) {
      showSnackbar("Failed to fetch user data: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
            Text(
              "Welcome, Glad to see you!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            _buildTextField("Email Address", emailController),
            _buildTextField("Password", passwordController, isPassword: true),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text("Forgot Password?", style: TextStyle(color: Colors.white)),
              ),
            ),
            isLoading
                ? CircularProgressIndicator()
                : _buildButton("Login", loginUser),
            TextButton(
              onPressed: () {},
              child: Text("Don't have an account? Sign Up Now", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
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

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
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





// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../screens/home_screen/home_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool isLoading = false;
//
//   // Function to handle login
//   void loginUser() async {
//     setState(() => isLoading = true);
//
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//
//       User? user = userCredential.user;
//       if (user != null) {
//         print("✅ Logged in successfully, UID: ${user.uid}");
//         navigateToHome(user.uid);
//       } else {
//         print("❌ Login failed, user is null");
//         showSnackbar("Login failed. Please try again.");
//       }
//     } catch (e) {
//       print("❌ Error: $e");
//       showSnackbar("Error: ${e.toString()}");
//       setState(() => isLoading = false);
//     }
//   }
//
//   // Function to navigate to home screen based on user role
//   void navigateToHome(String userId) async {
//     try {
//       print("🔍 Fetching user data for UID: $userId");
//
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//
//       if (userDoc.exists) {
//         print("✅ User data found: ${userDoc.data()}");
//
//         if (userDoc.data() != null && userDoc['role'] != null) {
//           String role = userDoc['role'];
//           print("🎭 User role: $role");
//
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//           );
//         } else {
//           print("⚠️ 'role' field missing in Firestore document");
//           showSnackbar("User data is incomplete.");
//         }
//       } else {
//         print("❌ No document found for this UID");
//         showSnackbar("User data not found!");
//       }
//     } catch (e) {
//       print("❌ Error fetching user data: $e");
//       showSnackbar("Failed to fetch user data: ${e.toString()}");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   // Function to show error messages
//   void showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.green.shade300, Colors.blue.shade200],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Welcome, Glad to see you!",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 20),
//             _buildTextField("Email Address", emailController),
//             _buildTextField("Password", passwordController, isPassword: true),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {}, // Add Forgot Password Functionality
//                 child: Text("Forgot Password?", style: TextStyle(color: Colors.white)),
//               ),
//             ),
//             isLoading
//                 ? CircularProgressIndicator()
//                 : _buildButton("Login", loginUser),
//             TextButton(
//               onPressed: () {}, // Add Sign Up Navigation
//               child: Text("Don't have an account? Sign Up Now", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String hint, TextEditingController controller, {bool isPassword = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           hintText: hint,
//           fillColor: Colors.white,
//           filled: true,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String text, VoidCallback onPressed) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           minimumSize: Size(double.infinity, 50),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         child: Text(text),
//       ),
//     );
//   }
// }
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../screens/home_screen/home_screen.dart';
// //
// // class LoginScreen extends StatefulWidget {
// //   @override
// //   _LoginScreenState createState() => _LoginScreenState();
// // }
// //
// // class _LoginScreenState extends State<LoginScreen> {
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   bool isLoading = false;
// //
// //   void loginUser() async {
// //     setState(() => isLoading = true);
// //     try {
// //       // Authenticate user
// //       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
// //         email: emailController.text.trim(),
// //         password: passwordController.text.trim(),
// //       );
// //
// //       // Navigate based on user role
// //       navigateToHome(userCredential.user!.uid);
// //     } catch (e) {
// //       setState(() => isLoading = false);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Error: ${e.toString()}")),
// //       );
// //     }
// //   }
// //
// //   void navigateToHome(String userId) async {
// //     try {
// //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(userId)
// //           .get();
// //
// //       if (userDoc.exists) {
// //         String role = userDoc['role'];
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => HomeScreen()),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text("User data not found! Please contact support.")),
// //         );
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("Failed to fetch user data: ${e.toString()}")),
// //       );
// //     } finally {
// //       if (mounted) {
// //         setState(() => isLoading = false);
// //       }
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         padding: EdgeInsets.all(20),
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [Colors.green.shade300, Colors.blue.shade200],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Text(
// //               "Welcome, Glad to see you!",
// //               style: TextStyle(
// //                 fontSize: 22,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.white,
// //               ),
// //             ),
// //             SizedBox(height: 20),
// //             _buildTextField("Email Address", emailController),
// //             _buildTextField("Password", passwordController, isPassword: true),
// //             Align(
// //               alignment: Alignment.centerRight,
// //               child: TextButton(
// //                 onPressed: () {}, // Add Forgot Password Functionality
// //                 child: Text("Forgot Password?", style: TextStyle(color: Colors.white)),
// //               ),
// //             ),
// //             isLoading
// //                 ? CircularProgressIndicator()
// //                 : _buildButton("Login", loginUser),
// //             TextButton(
// //               onPressed: () {}, // Add Sign Up Navigation
// //               child: Text("Don't have an account? Sign Up Now", style: TextStyle(color: Colors.white)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTextField(String hint, TextEditingController controller, {bool isPassword = false}) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 10),
// //       child: TextField(
// //         controller: controller,
// //         obscureText: isPassword,
// //         decoration: InputDecoration(
// //           hintText: hint,
// //           fillColor: Colors.white,
// //           filled: true,
// //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildButton(String text, VoidCallback onPressed) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 10),
// //       child: ElevatedButton(
// //         onPressed: onPressed,
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: Colors.white,
// //           foregroundColor: Colors.black,
// //           minimumSize: Size(double.infinity, 50),
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //         ),
// //         child: Text(text),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import '../screens/home_screen/home_screen.dart';
// // //
// // // class LoginScreen extends StatefulWidget {
// // //   @override
// // //   _LoginScreenState createState() => _LoginScreenState();
// // // }
// // //
// // // class _LoginScreenState extends State<LoginScreen> {
// // //   final TextEditingController emailController = TextEditingController();
// // //   final TextEditingController passwordController = TextEditingController();
// // //   final FirebaseAuth _auth = FirebaseAuth.instance;
// // //   bool isLoading = false;
// // //
// // //   void loginUser() async {
// // //     setState(() => isLoading = true);
// // //     try {
// // //       // Check if user already logged in to avoid unnecessary login attempts
// // //       User? currentUser = _auth.currentUser;
// // //       if (currentUser != null) {
// // //         navigateToHome(currentUser.uid);
// // //         return;
// // //       }
// // //
// // //       // Authenticate user
// // //       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
// // //         email: emailController.text.trim(),
// // //         password: passwordController.text.trim(),
// // //       );
// // //
// // //       // Navigate based on user role
// // //       navigateToHome(userCredential.user!.uid);
// // //     } catch (e) {
// // //       setState(() => isLoading = false);
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text("Error: ${e.toString()}")),
// // //       );
// // //     }
// // //   }
// // //
// // //   void navigateToHome(String userId) async {
// // //     try {
// // //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
// // //           .collection('users')
// // //           .doc(userId)
// // //           .get();
// // //
// // //       if (userDoc.exists) {
// // //         String role = userDoc['role'];
// // //         // Navigate to respective home screen
// // //         Navigator.pushReplacement(
// // //           context,
// // //           MaterialPageRoute(builder: (context) => HomeScreen()),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text("Failed to fetch user data: ${e.toString()}")),
// // //       );
// // //     } finally {
// // //       setState(() => isLoading = false);
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: Container(
// // //         padding: EdgeInsets.all(20),
// // //         decoration: BoxDecoration(
// // //           gradient: LinearGradient(
// // //             colors: [Colors.green.shade300, Colors.blue.shade200],
// // //             begin: Alignment.topCenter,
// // //             end: Alignment.bottomCenter,
// // //           ),
// // //         ),
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Text(
// // //               "Welcome, Glad to see you!",
// // //               style: TextStyle(
// // //                 fontSize: 22,
// // //                 fontWeight: FontWeight.bold,
// // //                 color: Colors.white,
// // //               ),
// // //             ),
// // //             SizedBox(height: 20),
// // //             _buildTextField("Email Address", emailController),
// // //             _buildTextField("Password", passwordController, isPassword: true),
// // //             Align(
// // //               alignment: Alignment.centerRight,
// // //               child: TextButton(
// // //                 onPressed: () {}, // Add Forgot Password Functionality
// // //                 child: Text("Forgot Password?", style: TextStyle(color: Colors.white)),
// // //               ),
// // //             ),
// // //             isLoading
// // //                 ? CircularProgressIndicator()
// // //                 : _buildButton("Login", loginUser),
// // //             TextButton(
// // //               onPressed: () {}, // Add Sign Up Navigation
// // //               child: Text("Don't have an account? Sign Up Now", style: TextStyle(color: Colors.white)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildTextField(String hint, TextEditingController controller, {bool isPassword = false}) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(vertical: 10),
// // //       child: TextField(
// // //         controller: controller,
// // //         obscureText: isPassword,
// // //         decoration: InputDecoration(
// // //           hintText: hint,
// // //           fillColor: Colors.white,
// // //           filled: true,
// // //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildButton(String text, VoidCallback onPressed) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(vertical: 10),
// // //       child: ElevatedButton(
// // //         onPressed: onPressed,
// // //         style: ElevatedButton.styleFrom(
// // //           backgroundColor: Colors.white,
// // //           foregroundColor: Colors.black,
// // //           minimumSize: Size(double.infinity, 50),
// // //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// // //         ),
// // //         child: Text(text),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // //
// // //
// // // Future<void> loginUser(String email, String password) async {
// // //   try {
// // //     await FirebaseAuth.instance.signInWithEmailAndPassword(
// // //       email: email,
// // //       password: password,
// // //     );
// // //     print("✅ Login Successful");
// // //   } catch (e) {
// // //     print("❌ Error: $e");
// // //   }
// // // }
