import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  late UserModel _currentUserData;
  bool _isLoading = true; // Track loading state

  UserModel get currentUserData => _currentUserData;
  bool get isLoading => _isLoading;

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        _currentUserData = UserModel(
          userName: doc["name"] ?? "Guest",
          userEmail: doc["email"] ?? "",
          userImage: doc["imageUrl"] ??
              "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-High-Quality-Image.png", // Default image
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching user data: $e");
      _isLoading = false;
      notifyListeners();
    }
  }
}

// User Model
class UserModel {
  final String userName;
  final String userEmail;
  final String userImage;

  UserModel({
    required this.userName,
    required this.userEmail,
    required this.userImage,
  });
}




// import 'package:agri_market/models/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
//
// class UserProvider with ChangeNotifier {
//   void addUserData(
//       {required User currentUser,
//         required String userName,
//         required String userEmail,
//         required String userImage}) async {
//     await FirebaseFirestore.instance.collection("userData")
//         .doc(currentUser.uid)
//         .set({
//       "userName": userName,
//       "userEmail": userEmail,
//       "userImage": userImage,
//       "userId": currentUser.uid,
//
//     });
//   }
//
//   late UserModel currentData;
//
//   void getUserData() async {
//     UserModel userModel;
//     var value = await FirebaseFirestore.instance.collection("userData")
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .get();
//
//     if (value.exists) {
//       userModel = UserModel(
//           userEmail: value.get("userEmail"),
//           userImage: value.get("userImage"),
//           userName: value.get("userName"),
//           userId: value.get("userId")
//       );
//       currentData = userModel;
//       notifyListeners();
//     }
//   }
//
//   UserModel get currentUserData{
//     return currentData;
//
//   }
// }