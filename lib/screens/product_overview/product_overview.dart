import 'package:agri_market/config/colors.dart';
import 'package:agri_market/providers/wish_list_provider.dart';
import 'package:agri_market/screens/review_cart/review_cart.dart';
import 'package:agri_market/widgets/count.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  int stockCount = 0; // Holds the stock value

  @override
  void initState() {
    super.initState();
    fetchStockCount();
    getWishlistBool();
  }

  // Function to fetch stock count from Firestore
  void fetchStockCount() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("Products")
          .doc(widget.productId)
          .get();

      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey("stock")) {
          setState(() {
            stockCount = data["stock"];
          });
        }
      }
      print("Fetched Stock: $stockCount"); // Debugging
    } catch (e) {
      print("Error fetching stock: $e"); // Debugging
    }
  }

  // Function to fetch wishlist status
  void getWishlistBool() async {
    try {
      DocumentSnapshot value = await FirebaseFirestore.instance
          .collection("WishList")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("YourWishList")
          .doc(widget.productId)
          .get();

      if (mounted) {
        setState(() {
          wishListBool = value.exists &&
              value.data() != null &&
              (value.data() as Map<String, dynamic>).containsKey("wishList")
              ? value.get("wishList")
              : false;
        });
      }
    } catch (e) {
      print("Error fetching wishlist: $e");
    }
  }

  // Function to update stock when a product is added
  void updateStock(int quantity) async {
    try {
      int newStock = stockCount - quantity;
      if (newStock < 0) newStock = 0; // Prevent negative stock

      await FirebaseFirestore.instance
          .collection("Products")
          .doc(widget.productId)
          .update({"stock": newStock});

      setState(() {
        stockCount = newStock;
      });

      print("Updated Stock: $stockCount"); // Debugging
    } catch (e) {
      print("Error updating stock: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    WishListProvider wishListProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          "Product Overview",
          style: TextStyle(color: textColor),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                "Stock: $stockCount",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About This Product",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "In marketing, a product is an object, system, or service made available for consumer use as per consumer demand...",
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  ListTile(
                    title: Text(widget.productName),
                    subtitle: Text("\₹${widget.productPrice}"),
                  ),
                  Container(
                    height: 250,
                    padding: EdgeInsets.all(40),
                    child: Image.network(
                      widget.productImage ?? "",
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Text(
                      "Available Options",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: Colors.green[700],
                            ),
                            Radio<SinginCharacter>(
                              value: SinginCharacter.fill,
                              groupValue: _character,
                              activeColor: Colors.green[700],
                              onChanged: (value) {
                                setState(() {
                                  _character = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        Text("\₹${widget.productPrice}"),
                        Count(
                          productId: widget.productId,
                          productImage: widget.productImage,
                          productName: widget.productName,
                          productPrice: widget.productPrice,
                          onItemAdded: (quantity) {
                            updateStock(quantity);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  wishListBool = !wishListBool;
                });

                if (wishListBool) {
                  wishListProvider.addWishListData(
                    wishListId: widget.productId,
                    wishListImage: widget.productImage,
                    wishListName: widget.productName,
                    wishlistPrice: widget.productPrice,
                    wishListQuantity: 1,
                  );
                } else {
                  wishListProvider.deleteWishList(widget.productId);
                }
              },
              child: Container(
                padding: EdgeInsets.all(20),
                color: textColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      wishListBool ? Icons.favorite : Icons.favorite_outline,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Add To Wishlist",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReviewCart(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(20),
                color: primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.black),
                    SizedBox(width: 5),
                    Text("Go To Cart", style: TextStyle(color: textColor)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



