import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agri_market/auth/welcomescreen.dart';
import 'package:agri_market/config/colors.dart';
import 'package:agri_market/screens/home_screen/home_screen.dart';
import 'package:agri_market/screens/my_profile/my_profile.dart';
import 'package:agri_market/screens/review_cart/review_cart.dart';
import 'package:agri_market/screens/wish_list/wish_list.dart';

class DrawerSide extends StatefulWidget {
  @override
  _DrawerSideState createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  // Function to fetch user email from Firestore
  Future<void> fetchUserEmail() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

        if (userDoc.exists) {
          setState(() {
            userEmail = userDoc['email']; // Fetch email field
          });
        } else {
          setState(() {
            userEmail = "No email found";
          });
        }
      } catch (e) {
        setState(() {
          userEmail = "Error fetching email";
        });
      }
    }
  }

  Widget listTile({
    required String title,
    required IconData iconData,
    required Function() onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(iconData, size: 30, color: Colors.black87),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFFD4FBD8), // Light Green Background
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : AssetImage("assets/default_avatar.png") as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user?.displayName ?? "Guest User",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userEmail ?? "Fetching email...",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Menu Options
            Expanded(
              child: Column(
                children: [
                  listTile(
                    iconData: Icons.home_outlined,
                    title: "Home",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                  listTile(
                    iconData: Icons.shop_outlined,
                    title: "Review Cart",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ReviewCart()),
                      );
                    },
                  ),
                  listTile(
                    iconData: Icons.person_outlined,
                    title: "My Profile",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyProfile()),
                      );
                    },
                  ),
                  listTile(
                    iconData: Icons.favorite_outlined,
                    title: "WishList",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WishList()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text("Logout", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:agri_market/auth/welcomescreen.dart';
// import 'package:agri_market/config/colors.dart';
// import 'package:agri_market/screens/home_screen/home_screen.dart';
// import 'package:agri_market/screens/my_profile/my_profile.dart';
// import 'package:agri_market/screens/review_cart/review_cart.dart';
// import 'package:agri_market/screens/wish_list/wish_list.dart';
//
// class DrawerSide extends StatelessWidget {
//   final User? user = FirebaseAuth.instance.currentUser; // Get current user
//
//   Widget listTile({
//     required String title,
//     required IconData iconData,
//     required Function() onTap,
//   }) {
//     return ListTile(
//       onTap: onTap,
//       leading: Icon(iconData, size: 30, color: Colors.black87),
//       title: Text(
//         title,
//         style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//         color: Color(0xFFD4FBD8), // Light Green Background
//         child: Column(
//           children: [
//             // Profile Section
//             Container(
//               padding: EdgeInsets.only(top: 50, bottom: 20),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade100,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.white,
//                     child: CircleAvatar(
//                       radius: 48,
//                       backgroundImage: user?.photoURL != null
//                           ? NetworkImage(user!.photoURL!)
//                           : AssetImage("assets/default_avatar.png") as ImageProvider,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     user?.displayName ?? "Guest User",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Menu Options
//             Expanded(
//               child: Column(
//                 children: [
//                   listTile(
//                     iconData: Icons.home_outlined,
//                     title: "Home",
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => HomeScreen()),
//                       );
//                     },
//                   ),
//                   listTile(
//                     iconData: Icons.shop_outlined,
//                     title: "Review Cart",
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => ReviewCart()),
//                       );
//                     },
//                   ),
//                   listTile(
//                     iconData: Icons.person_outlined,
//                     title: "My Profile",
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => MyProfile()),
//                       );
//                     },
//                   ),
//                   listTile(
//                     iconData: Icons.favorite_outlined,
//                     title: "WishList",
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => WishList()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//
//             // Logout Button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                   ),
//                   onPressed: () async {
//                     await FirebaseAuth.instance.signOut();
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => WelcomeScreen()),
//                     );
//                   },
//                   icon: Icon(Icons.logout, color: Colors.white),
//                   label: Text("Logout", style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:agri_market/auth/sign_in.dart';
// // import 'package:agri_market/config/colors.dart';
// // import 'package:agri_market/screens/home_screen/home_screen.dart';
// // import 'package:agri_market/screens/my_profile/my_profile.dart';
// // import 'package:agri_market/screens/review_cart/review_cart.dart';
// // import 'package:agri_market/screens/wish_list/wish_list.dart';
// //
// // import '../../auth/welcomescreen.dart';
// //
// // class DrawerSide extends StatefulWidget {
// //   const DrawerSide({Key? key}) : super(key: key);
// //
// //   @override
// //   _DrawerSideState createState() => _DrawerSideState();
// // }
// //
// // class _DrawerSideState extends State<DrawerSide> {
// //   final User? user = FirebaseAuth.instance.currentUser; // Get current user
// //
// //   Widget listTile({
// //     required String title,
// //     required IconData iconData,
// //     required Function() onTap,
// //   }) {
// //     return ListTile(
// //       onTap: onTap,
// //       leading: Icon(iconData, size: 30, color: Colors.black87),
// //       title: Text(
// //         title,
// //         style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Drawer(
// //       child: Container(
// //         color: Color(0xFFD4FBD8), // Light Green Background
// //         child: Column(
// //           children: [
// //             // Profile Section
// //             Container(
// //               padding: EdgeInsets.only(top: 50, bottom: 20),
// //               decoration: BoxDecoration(
// //                 color: Colors.green.shade100,
// //                 borderRadius: BorderRadius.only(
// //                   bottomLeft: Radius.circular(20),
// //                   bottomRight: Radius.circular(20),
// //                 ),
// //               ),
// //               child: Column(
// //                 children: [
// //                   CircleAvatar(
// //                     radius: 50,
// //                     backgroundColor: Colors.white,
// //                     child: CircleAvatar(
// //                       radius: 48,
// //                       backgroundImage: user?.photoURL != null
// //                           ? NetworkImage(user!.photoURL!)
// //                           : AssetImage("assets/default_avatar.png") as ImageProvider,
// //                     ),
// //                   ),
// //                   SizedBox(height: 10),
// //                   Text(
// //                     user?.displayName ?? "Guest User",
// //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             // Menu Options
// //             Expanded(
// //               child: Column(
// //                 children: [
// //                   listTile(
// //                     iconData: Icons.home_outlined,
// //                     title: "Home",
// //                     onTap: () {
// //                       Navigator.of(context).pushReplacement(
// //                         MaterialPageRoute(builder: (context) => HomeScreen()),
// //                       );
// //                     },
// //                   ),
// //                   listTile(
// //                     iconData: Icons.shop_outlined,
// //                     title: "Review Cart",
// //                     onTap: () {
// //                       Navigator.of(context).pushReplacement(
// //                         MaterialPageRoute(builder: (context) => ReviewCart()),
// //                       );
// //                     },
// //                   ),
// //                   listTile(
// //                     iconData: Icons.person_outlined,
// //                     title: "My Profile",
// //                     onTap: () {
// //                       Navigator.of(context).pushReplacement(
// //                         MaterialPageRoute(builder: (context) => MyProfile()),
// //                       );
// //                     },
// //                   ),
// //                   listTile(
// //                     iconData: Icons.favorite_outlined,
// //                     title: "WishList",
// //                     onTap: () {
// //                       Navigator.of(context).pushReplacement(
// //                         MaterialPageRoute(builder: (context) => WishList()),
// //                       );
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             // Logout Button
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //               child: SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton.icon(
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.redAccent,
// //                     padding: EdgeInsets.symmetric(vertical: 12),
// //                   ),
// //                   onPressed: () async {
// //                     await FirebaseAuth.instance.signOut();
// //                     Navigator.of(context).pushReplacement(
// //                       MaterialPageRoute(builder: (context) => WelcomeScreen()),
// //                     );
// //                   },
// //                   icon: Icon(Icons.logout, color: Colors.white),
// //                   label: Text("Logout", style: TextStyle(color: Colors.white)),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// // // import 'package:agri_market/auth/sign_in.dart';
// // // import 'package:agri_market/config/colors.dart';
// // // import 'package:agri_market/providers/user_provider.dart';
// // // import 'package:agri_market/screens/home_screen/home_screen.dart';
// // // import 'package:agri_market/screens/my_profile/my_profile.dart';
// // // import 'package:agri_market/screens/review_cart/review_cart.dart';
// // // import 'package:agri_market/screens/wish_list/wish_list.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';
// // //
// // // import '../../auth/welcomescreen.dart';
// // //
// // // class DrawerSide extends StatefulWidget {
// // //   final UserProvider userProvider;
// // //
// // //   const DrawerSide({Key? key, required this.userProvider}) : super(key: key);
// // //
// // //   @override
// // //   _DrawerSideState createState() => _DrawerSideState();
// // // }
// // //
// // // class _DrawerSideState extends State<DrawerSide> {
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     widget.userProvider.fetchUserData(); // Fetch user data on init
// // //   }
// // //
// // //   Widget listTile({
// // //     required String title,
// // //     required IconData iconData,
// // //     required Function() onTap,
// // //   }) {
// // //     return ListTile(
// // //       onTap: onTap,
// // //       leading: Icon(iconData, size: 30, color: Colors.black87),
// // //       title: Text(
// // //         title,
// // //         style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
// // //       ),
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Consumer<UserProvider>(
// // //       builder: (context, userProvider, child) {
// // //         if (userProvider.isLoading) {
// // //           return Drawer(
// // //             child: Center(child: CircularProgressIndicator()),
// // //           );
// // //         }
// // //
// // //         var userData = userProvider.currentUserData;
// // //         if (userData == null) {
// // //           return Drawer(
// // //             child: Center(child: Text("User data not found!")),
// // //           );
// // //         }
// // //
// // //         return Drawer(
// // //           child: Container(
// // //             color: Color(0xFFD4FBD8), // Light Green Background
// // //             child: Column(
// // //               children: [
// // //                 // Profile Section
// // //                 Container(
// // //                   padding: EdgeInsets.only(top: 50, bottom: 20),
// // //                   decoration: BoxDecoration(
// // //                     color: Colors.green.shade100,
// // //                     borderRadius: BorderRadius.only(
// // //                       bottomLeft: Radius.circular(20),
// // //                       bottomRight: Radius.circular(20),
// // //                     ),
// // //                   ),
// // //                   child: Column(
// // //                     children: [
// // //                       CircleAvatar(
// // //                         radius: 50,
// // //                         backgroundColor: Colors.white,
// // //                         child: CircleAvatar(
// // //                           radius: 48,
// // //                           backgroundImage: NetworkImage(userData.userImage),
// // //                         ),
// // //                       ),
// // //                       SizedBox(height: 10),
// // //                       Text(
// // //                         userData.userName,
// // //                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //
// // //                 // Menu Options
// // //                 Expanded(
// // //                   child: Column(
// // //                     children: [
// // //                       listTile(
// // //                         iconData: Icons.home_outlined,
// // //                         title: "Home",
// // //                         onTap: () {
// // //                           Navigator.of(context).pushReplacement(
// // //                             MaterialPageRoute(builder: (context) => HomeScreen()),
// // //                           );
// // //                         },
// // //                       ),
// // //                       listTile(
// // //                         iconData: Icons.shop_outlined,
// // //                         title: "Review Cart",
// // //                         onTap: () {
// // //                           Navigator.of(context).pushReplacement(
// // //                             MaterialPageRoute(builder: (context) => ReviewCart()),
// // //                           );
// // //                         },
// // //                       ),
// // //                       listTile(
// // //                         iconData: Icons.person_outlined,
// // //                         title: "My Profile",
// // //                         onTap: () {
// // //                           Navigator.of(context).pushReplacement(
// // //                             MaterialPageRoute(
// // //                               builder: (context) => MyProfile(userProvider: userProvider),
// // //                             ),
// // //                           );
// // //                         },
// // //                       ),
// // //                       listTile(
// // //                         iconData: Icons.favorite_outlined,
// // //                         title: "WishList",
// // //                         onTap: () {
// // //                           Navigator.of(context).pushReplacement(
// // //                             MaterialPageRoute(builder: (context) => WishList()),
// // //                           );
// // //                         },
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //
// // //                 // Logout Button
// // //                 Padding(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// // //                   child: SizedBox(
// // //                     width: double.infinity,
// // //                     child: ElevatedButton.icon(
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: Colors.redAccent,
// // //                         padding: EdgeInsets.symmetric(vertical: 12),
// // //                       ),
// // //                       onPressed: () async {
// // //                         await FirebaseAuth.instance.signOut();
// // //                         Navigator.of(context).pushReplacement(
// // //                           MaterialPageRoute(builder: (context) => WelcomeScreen()),
// // //                         );
// // //                       },
// // //                       icon: Icon(Icons.logout, color: Colors.white),
// // //                       label: Text("Logout", style: TextStyle(color: Colors.white)),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }
// // //
// // //
