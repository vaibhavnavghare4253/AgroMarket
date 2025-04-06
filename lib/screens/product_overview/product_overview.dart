import 'package:agri_market/config/colors.dart';
import 'package:agri_market/providers/review_cart_provider.dart';
import 'package:agri_market/providers/wish_list_provider.dart';
import 'package:agri_market/screens/review_cart/review_cart.dart';
import 'package:agri_market/widgets/count.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'StockPage.dart';

enum SinginCharacter { fill, outline }

class ProductOverview extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productPrice;
  final String productId;

  ProductOverview({
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productId,
  });

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  SinginCharacter _character = SinginCharacter.fill;
  bool wishListBool = false;
  int stockCount = 0;

  final List<String> collections = ['FruitsProduct', 'GrainsProduct', 'VegetablesProduct'];
  String? foundCollection;

  @override
  void initState() {
    super.initState();
    fetchStockCount();
    getWishlistBool();
  }

  void fetchStockCount() async {
    for (String collection in collections) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(collection)
          .doc(widget.productId)
          .get();

      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey("stock")) {
          setState(() {
            stockCount = (data["stock"] is int) ? data["stock"] : int.tryParse(data["stock"].toString()) ?? 0;
            foundCollection = collection;
          });
          break;
        }
      }
    }
  }

  Future<void> reduceStock(int quantity) async {
    if (foundCollection == null) return;

    int newStock = stockCount - quantity;
    if (newStock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not enough stock available")),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection(foundCollection!)
        .doc(widget.productId)
        .update({'stock': newStock});

    setState(() {
      stockCount = newStock;
    });
  }

  String getStockStatus() {
    if (stockCount == 0) return "Out of Stock";
    if (stockCount > 50) return "Available";
    if (stockCount > 10) return "Only Few Left";
    return "Low Stock";
  }

  void getWishlistBool() async {
    DocumentSnapshot value = await FirebaseFirestore.instance
        .collection("WishList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("YourWishList")
        .doc(widget.productId)
        .get();

    if (value.exists) {
      setState(() {
        wishListBool = value.get("wishList");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ReviewCartProvider reviewCartProvider = Provider.of(context);
    WishListProvider wishListProvider = Provider.of(context);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ReviewCart()),
                    );
                  },
                  child: Text("Go to Cart"),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: stockCount > 0
                      ? () async {
                    await reduceStock(1);

                    reviewCartProvider.addReviewCartData(
                      cartId: widget.productId,
                      cartName: widget.productName,
                      cartImage: widget.productImage,
                      cartPrice: widget.productPrice,
                      cartQuantity: 1,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Item added to cart")),
                    );
                  }
                      : null,
                  child: Text("Add to Cart"),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          "Product Overview",
          style: TextStyle(color: textColor),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: 300,
            padding: EdgeInsets.all(20),
            child: Image.network(widget.productImage),
          ),
          ListTile(
            title: Text(widget.productName),
            subtitle: Text("\₹${widget.productPrice}"),
            trailing: Text(getStockStatus()),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text("Product Description"),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "This is a healthy and fresh item. You can add it to your cart and place an order.",
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}





// import 'package:agri_market/config/colors.dart';
// import 'package:agri_market/providers/review_cart_provider.dart';
// import 'package:agri_market/providers/wish_list_provider.dart';
// import 'package:agri_market/screens/review_cart/review_cart.dart';
// import 'package:agri_market/widgets/count.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'StockPage.dart';
//
// enum SinginCharacter { fill, outline }
//
// class ProductOverview extends StatefulWidget {
//   final String productName;
//   final String productImage;
//   final int productPrice;
//   final String productId;
//
//   ProductOverview({
//     required this.productName,
//     required this.productImage,
//     required this.productPrice,
//     required this.productId,
//   });
//
//   @override
//   _ProductOverviewState createState() => _ProductOverviewState();
// }
//
// class _ProductOverviewState extends State<ProductOverview> {
//   SinginCharacter _character = SinginCharacter.fill;
//   bool wishListBool = false;
//   int stockCount = 0; // Holds the stock value
//
//   @override
//   void initState() {
//     super.initState();
//     fetchStockCount();
//     getWishlistBool();
//   }
//
//   void fetchStockCount() async {
//     try {
//       DocumentSnapshot doc = await FirebaseFirestore.instance
//           .collection("Products")
//           .doc(widget.productId)
//           .get();
//
//       if (doc.exists && doc.data() != null) {
//         var data = doc.data() as Map<String, dynamic>;
//         if (data.containsKey("stock")) {
//           setState(() {
//             stockCount = (data["stock"] is int) ? data["stock"] : int.tryParse(data["stock"].toString()) ?? 0;
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching stock: $e");
//     }
//   }
//
//   String getStockStatus() {
//     if (stockCount == 0) return "Out of Stock";
//     if (stockCount > 50) return "Available";
//     if (stockCount > 10) return "Only Few Left";
//     return "Low Stock";
//   }
//
//   void getWishlistBool() async {
//     try {
//       DocumentSnapshot value = await FirebaseFirestore.instance
//           .collection("WishList")
//           .doc(FirebaseAuth.instance.currentUser?.uid)
//           .collection("YourWishList")
//           .doc(widget.productId)
//           .get();
//
//       if (mounted) {
//         setState(() {
//           wishListBool = value.exists && value.get("wishList") == true;
//         });
//       }
//     } catch (e) {
//       print("Error fetching wishlist: $e");
//     }
//   }
//
//   void toggleWishlist(WishListProvider wishListProvider) {
//     setState(() {
//       wishListBool = !wishListBool;
//     });
//
//     if (wishListBool) {
//       wishListProvider.addWishListData(
//         wishListId: widget.productId,
//         wishListImage: widget.productImage,
//         wishListName: widget.productName,
//         wishlistPrice: widget.productPrice,
//         wishListQuantity: widget.productPrice,
//       );
//     } else {
//       wishListProvider.deleteWishList(widget.productId);
//     }
//   }
//
//   void updateStock(int quantity) async {
//     try {
//       int newStock = stockCount - quantity;
//       if (newStock < 0) newStock = 0;
//
//       await FirebaseFirestore.instance
//           .collection("Products")
//           .doc(widget.productId)
//           .update({"stock": newStock});
//
//       setState(() {
//         stockCount = newStock;
//       });
//     } catch (e) {
//       print("Error updating stock: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     WishListProvider wishListProvider = Provider.of(context);
//     ReviewCartProvider reviewCartProvider = Provider.of(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: textColor),
//         title: Text("Product Overview", style: TextStyle(color: textColor)),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 shape: StadiumBorder(),
//                 side: BorderSide(color: primaryColor),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => StockPage(
//                       productId: widget.productId,
//                       productName: widget.productName,
//                     ),
//                   ),
//                 );
//               },
//               child: Text(
//                 "Stock",
//                 style: TextStyle(color: primaryColor),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("About This Product", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//                   SizedBox(height: 15),
//                   Text("Description of the product goes here...", style: TextStyle(fontSize: 16, color: textColor)),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Column(
//               children: [
//                 ListTile(title: Text(widget.productName), subtitle: Text("\₹${widget.productPrice}")),
//                 Container(height: 250, padding: EdgeInsets.all(40), child: Image.network(widget.productImage)),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("\₹${widget.productPrice}"),
//                       Count(
//                         productId: widget.productId,
//                         productImage: widget.productImage,
//                         productName: widget.productName,
//                         productPrice: widget.productPrice,
//                         onItemAdded: (quantity) {
//                           updateStock(quantity);
//                           reviewCartProvider.addReviewCartData(
//                             cartId: widget.productId,
//                             cartImage: widget.productImage,
//                             cartName: widget.productName,
//                             cartPrice: widget.productPrice,
//                             cartQuantity: quantity,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.all(20),
//         color: primaryColor,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               icon: Icon(
//                 wishListBool ? Icons.favorite : Icons.favorite_border,
//                 color: wishListBool ? Colors.red : Colors.white,
//               ),
//               onPressed: () => toggleWishlist(wishListProvider),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewCart()));
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.black),
//                   SizedBox(width: 5),
//                   Text("Go To Cart", style: TextStyle(color: textColor)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
