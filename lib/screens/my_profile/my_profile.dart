import 'package:agri_market/screens/retunrn%20policy/return_policy_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agri_market/config/colors.dart';
import 'package:agri_market/screens/home_screen/drawer_side.dart';
import '../../auth/welcomescreen.dart';
import '../check_out/dilevery_details/dilevery_delails.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final User? user = FirebaseAuth.instance.currentUser;

  String userEmail = "No Email";
  String userImage = "assets/default_avatar.png";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch user details from Firestore
  Future<void> fetchUserData() async {
    if (user != null) {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();

      if (userDoc.exists) {
        setState(() {
          userEmail = userDoc["email"] ?? "No Email";
          userImage = userDoc["image"] ?? "assets/default_avatar.png";
        });
      } else {
        print("User document not found in Firestore.");
      }
    } else {
      print("User not logged in.");
    }
  }

  void navigateToScreen(String screenName) {
    // Replace these with actual navigation routes
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        switch (screenName) {
          case "My Delivery Address":
            return DeliveryDetails(); // Create this screen
          case "Return Policy":
            return ReturnPolicyScreen(); // Create this screen
          case "Terms & Conditions":
            return DeliveryDetails(); // Create this screen
          case "Privacy Policy":
            return DeliveryDetails(); // Create this screen
          case "About":
            return DeliveryDetails(); // Create this screen
          default:
            return MyProfile();
        }
      }),
    );
  }

  Widget listTile({required IconData icon, required String title}) {
    return Column(
      children: [
        Divider(height: 1),
        ListTile(
          leading: Icon(icon, color: Colors.black87),
          title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () => navigateToScreen(title), // Navigate on tap
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text("My Profile", style: TextStyle(fontSize: 18, color: textColor)),
      ),
      drawer: DrawerSide(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(height: 100, color: primaryColor),
                    Container(
                      height: screenHeight - 150,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 60), // Space for Profile Picture
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userEmail,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                listTile(icon: Icons.location_on_outlined, title: "My Delivery Address"),
                                listTile(icon: Icons.person_outline, title: "Return Policy"),
                                listTile(icon: Icons.file_copy_outlined, title: "Terms & Conditions"),
                                listTile(icon: Icons.policy_outlined, title: "Privacy Policy"),
                                listTile(icon: Icons.info_outline, title: "About"),

                                // Logout Button
                                ListTile(
                                  leading: Icon(Icons.exit_to_app_outlined, color: Colors.redAccent),
                                  title: Text("Log Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Profile Picture
                Positioned(
                  top: 40,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: scaffoldBackgroundColor,
                      backgroundImage: userImage.startsWith("http")
                          ? NetworkImage(userImage)
                          : AssetImage(userImage) as ImageProvider,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
