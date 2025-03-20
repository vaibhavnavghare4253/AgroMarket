import 'package:agri_market/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _searchList = [];

  List<ProductModel> get getAllProductSearch => _searchList;

  void _listenToProductData(String collectionName, List<ProductModel> productList) {
    FirebaseFirestore.instance.collection(collectionName).snapshots().listen((snapshot) {
      productList.clear();

      for (var element in snapshot.docs) {
        try {
          final product = ProductModel(
            productId: element.id, // Ensure productId exists
            productImage: element.get("productImage") ?? "",
            productName: element.get("productName") ?? "Unknown Product",
            productPrice: element.data() != null && element.data()!.containsKey("productPrice")
                ? (element.get("productPrice") is num
                ? (element.get("productPrice") as num).toDouble().round() // Convert to int
                : int.tryParse(element.get("productPrice").toString()) ?? 0)
                : 0,


          );

          productList.add(product);
        } catch (error) {
          print("Error processing product from $collectionName: $error");
        }
      }
      notifyListeners();
    });
  }

  void listenToAllProducts() {
    listenToGrainsProductData();
    listenToFruitsProductData();
    listenToVegetablesProductData();
  }

  List<ProductModel> _grainsProductList = [];
  void listenToGrainsProductData() {
    _listenToProductData("GrainsProduct", _grainsProductList);
  }
  List<ProductModel> get getGrainsProductDataList => _grainsProductList;

  List<ProductModel> _fruitsProductList = [];
  void listenToFruitsProductData() {
    _listenToProductData("FruitsProduct", _fruitsProductList);
  }
  List<ProductModel> get getFruitsProductDataList => _fruitsProductList;

  List<ProductModel> _vegetablesProductList = [];
  void listenToVegetablesProductData() {
    _listenToProductData("VegetablesProduct", _vegetablesProductList);
  }
  List<ProductModel> get getVegetablesProductDataList => _vegetablesProductList;
}


// import 'package:agri_market/models/product_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
//
// class ProductProvider with ChangeNotifier {
//   final List<ProductModel> _searchList = [];
//   List<ProductModel> get getAllProductSearch => _searchList;
//
//   void _listenToProductData(String collectionName, List<ProductModel> productList) {
//     FirebaseFirestore.instance.collection(collectionName).snapshots().listen((snapshot) {
//       productList.clear();
//
//       if (snapshot.docs.isEmpty) {
//         print("No products found in $collectionName");
//       }
//
//       for (var element in snapshot.docs) {
//         if (element.exists) {
//           try {
//             final product = ProductModel(
//               productId: element.get("productId") ?? element.id, // Ensure productId exists
//               productImage: element.get("productImage"),
//               productName: element.get("productName"),
//               productPrice: (element.get("productPrice") as num).toDouble(), // Ensure double type
//             );
//
//             productList.add(product);
//             print("Fetched product: ${product.productName}, Price: ${product.productPrice}");
//           } catch (e) {
//             print("Error processing document in $collectionName: $e");
//           }
//         }
//       }
//
//       notifyListeners(); // Ensure UI updates
//       print("$collectionName updated with ${productList.length} products");
//     });
//   }
//
//   void listenToAllProducts() {
//     listenToGrainsProductData();
//     listenToFruitsProductData();
//     listenToVegetablesProductData();
//   }
//
//   List<ProductModel> _grainsProductList = [];
//   void listenToGrainsProductData() {
//     _listenToProductData("GrainsProduct", _grainsProductList);
//   }
//   List<ProductModel> get getGrainsProductDataList => _grainsProductList;
//
//   List<ProductModel> _fruitsProductList = [];
//   void listenToFruitsProductData() {
//     _listenToProductData("FruitsProduct", _fruitsProductList);
//   }
//   List<ProductModel> get getFruitsProductDataList => _fruitsProductList;
//
//   List<ProductModel> _vegetablesProductList = [];
//   void listenToVegetablesProductData() {
//     _listenToProductData("VegetablesProduct", _vegetablesProductList);
//   }
//   List<ProductModel> get getVegetablesProductDataList => _vegetablesProductList;
// }
//
//
// // import 'package:agri_market/models/product_model.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/cupertino.dart';
// //
// // class ProductProvider with ChangeNotifier {
// //
// //   final List<ProductModel> _searchList = [];
// //
// //   List<ProductModel> get getAllProductSearch => _searchList;
// //
// //
// //   void _listenToProductData(String collectionName, List<ProductModel> productList) {
// //     FirebaseFirestore.instance.collection(collectionName).snapshots().listen((snapshot) {
// //       productList.clear();
// //       for (var element in snapshot.docs) {
// //         final product = ProductModel(
// //           productId: element.id, // Firestore's document ID
// //           productImage: element.get("productImage"),
// //           productName: element.get("productName"),
// //           productPrice: element.get("productPrice"),
// //         );
// //
// //         productList.add(product);
// //       }
// //       notifyListeners();
// //     });
// //   }
// //
// //   void listenToAllProducts() {
// //     listenToGrainsProductData();
// //     listenToFruitsProductData();
// //     listenToVegetablesProductData();
// //   }
// //
// //   List<ProductModel> _grainsProductList = [];
// //   void listenToGrainsProductData() {
// //     _listenToProductData("GrainsProduct", _grainsProductList);
// //   }
// //   List<ProductModel> get getGrainsProductDataList => _grainsProductList;
// //
// //   List<ProductModel> _fruitsProductList = [];
// //   void listenToFruitsProductData() {
// //     _listenToProductData("FruitsProduct", _fruitsProductList);
// //   }
// //   List<ProductModel> get getFruitsProductDataList => _fruitsProductList;
// //
// //   List<ProductModel> _vegetablesProductList = [];
// //   void listenToVegetablesProductData() {
// //     _listenToProductData("VegetablesProduct", _vegetablesProductList);
// //   }
// //   List<ProductModel> get getVegetablesProductDataList => _vegetablesProductList;
// // }
// //
// //
// //
// //
// // // import 'package:agri_market/models/product_model.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/cupertino.dart';
// // //
// // // class ProductProvider with ChangeNotifier {
// // //   final List<ProductModel> _searchList = [];
// // //
// // //   void _addProductToSearchList(QueryDocumentSnapshot element) {
// // //     final product = ProductModel(
// // //       productImage: element.get("productImage"),
// // //       productName: element.get("productName"),
// // //       productPrice: element.get("productPrice"),
// // //       productId: element.get("productId"),
// // //     );
// // //
// // //     _searchList.add(product);
// // //   }
// // //
// // //   List<ProductModel> get getAllProductSearch => _searchList;
// // //
// // //   /////////////////////////// Real-time Listener /////////////////////////
// // //
// // //   void _listenToProductData(String collectionName, List<ProductModel> productList) {
// // //     FirebaseFirestore.instance.collection(collectionName).snapshots().listen((snapshot) {
// // //       productList.clear(); // Clear old data to prevent duplicates
// // //       print("Fetching data from $collectionName...");
// // //
// // //       if (snapshot.docs.isEmpty) {
// // //         print("No products found in $collectionName");
// // //       }
// // //
// // //       for (var element in snapshot.docs) {
// // //         final product = ProductModel(
// // //           productImage: element.get("productImage"),
// // //           productName: element.get("productName"),
// // //           productPrice: element.get("productPrice"),
// // //           productId: element.get("productId"),
// // //         );
// // //
// // //         productList.add(product);
// // //         print("Fetched product: ${product.productName}, Price: ${product.productPrice}");
// // //       }
// // //
// // //       notifyListeners();
// // //       print("$collectionName updated with ${productList.length} products");
// // //     });
// // //   }
// // //
// // //
// // //   /////////////////////////// Grains Product /////////////////////////
// // //
// // //   List<ProductModel> _grainsProductList = [];
// // //   void listenToGrainsProductData() {
// // //     _listenToProductData("GrainsProduct", _grainsProductList);
// // //   }
// // //
// // //   List<ProductModel> get getGrainsProductDataList => _grainsProductList;
// // //
// // //   /////////////////////////// Fruits Product /////////////////////////
// // //
// // //   List<ProductModel> _fruitsProductList = [];
// // //   void listenToFruitsProductData() {
// // //     _listenToProductData("FruitsProduct", _fruitsProductList);
// // //   }
// // //
// // //   List<ProductModel> get getFruitsProductDataList => _fruitsProductList;
// // //
// // //   /////////////////////////// Vegetables Product /////////////////////////
// // //
// // //   List<ProductModel> _vegetablesProductList = [];
// // //   void listenToVegetablesProductData() {
// // //     _listenToProductData("VegetablesProduct", _vegetablesProductList);
// // //   }
// // //
// // //   List<ProductModel> get getVegetablesProductDataList => _vegetablesProductList;
// // // }
// // //
