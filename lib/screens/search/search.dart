import 'package:agri_market/models/product_model.dart';
import 'package:agri_market/widgets/single_item.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../home_screen/drawer_side.dart';

class Search extends StatefulWidget {
  final List<ProductModel> search;

  Search({required this.search});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = "";

  List<ProductModel> searchItem(String query) {
    if (query.isEmpty) {
      return widget.search;
    }
    return widget.search.where((element) {
      return element.productName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<ProductModel> _searchItem = searchItem(query);

    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        backgroundColor: Color(0xFF71F377),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back arrow icon
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // Go back to the previous screen safely
            } else {
              // If no previous screen, navigate to Home instead of black screen
              Navigator.pushReplacementNamed(context, "/home");
            }
          },
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Icon(Icons.menu_rounded),
        //   ),
        // ],
      ),
      // drawer: DrawerSide(),
      body: ListView(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: "Search for items in the store",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Search Results
          _searchItem.isEmpty
              ? Center(
            child: Lottie.asset(
              'assets/notFound.json', // Add your animation file
    ),
    ) : Column(
            children: _searchItem.map((data) {
              return SingleItem(
                isBool: false,
               //productId: data.productId,
                productImage: data.productImage,
                productName: data.productName,
                productPrice: data.productPrice,
                productId: data.productId,
               productQuantity: data.productQuantity?? 1,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
