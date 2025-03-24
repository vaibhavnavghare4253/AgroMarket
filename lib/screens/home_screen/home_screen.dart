import 'package:agri_market/config/colors.dart';
import 'package:agri_market/providers/product_provider.dart';
import 'package:agri_market/screens/home_screen/drawer_side.dart';
import 'package:agri_market/screens/product_overview/product_overview.dart';
import 'package:agri_market/screens/review_cart/review_cart.dart';
import 'package:agri_market/screens/search/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'single_product.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.listenToGrainsProductData();
    productProvider.listenToFruitsProductData();
    productProvider.listenToVegetablesProductData();
    print("Fetching product data...");
  }

  Widget _buildProductSection({
    required String title,
    required List<dynamic> productList,
    required Function onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => onTap(),
                child: Text('View All', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        productList.isEmpty
            ? Center(child: Text('No products available'))
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: productList.map((productData) {
              return SingleProduct(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductOverview(
                        productPrice: productData.productPrice,
                        productName: productData.productName,
                        productImage: productData.productImage,
                        productId: productData.productId,
                      ),
                    ),
                  );
                },
                productPrice: productData.productPrice,
                productImage: productData.productImage,
                productName: productData.productName,
                productId: productData.productId,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: Color(0xFFD4FBD8),
      drawer: DrawerSide(), // ✅ Updated drawer integration
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Home', style: TextStyle(color: Colors.black)),
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFB4F6B8),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Search(search: productProvider.getAllProductSearch),
                  ),
                );
              },
              icon: Icon(Icons.search_outlined, size: 18, color: textColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReviewCart()));
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFB4F6B8),
                child: Icon(Icons.shopping_cart, size: 18, color: Colors.black),
              ),
            ),
          ),
        ],
        backgroundColor: Color(0xFF71F377),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView(
          children: [
            _buildProductSection(
              title: 'Grains and Pulses',
              productList: productProvider.getGrainsProductDataList,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Search(search: productProvider.getGrainsProductDataList),
                  ),
                );
              },
            ),
            _buildProductSection(
              title: 'Fresh Fruits',
              productList: productProvider.getFruitsProductDataList,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Search(search: productProvider.getFruitsProductDataList),
                  ),
                );
              },
            ),
            _buildProductSection(
              title: 'Fresh Vegetables',
              productList: productProvider.getVegetablesProductDataList,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Search(search: productProvider.getVegetablesProductDataList),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
