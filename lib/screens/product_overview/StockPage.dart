import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../config/colors.dart';

class StockPage extends StatefulWidget {
  final String productId;
  final String productName;

  const StockPage({
    required this.productId,
    required this.productName,
    super.key,
  });

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final List<String> collections = ['FruitsProduct', 'GrainsProduct', 'VegetablesProduct'];

  int _stockCount = 0;
  String? foundCollection;
  late Map<String, dynamic> productData;

  Future<void> loadStock() async {
    for (String collection in collections) {
      final doc = await FirebaseFirestore.instance
          .collection(collection)
          .doc(widget.productId)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final stock = data['stock'];
        productData = data;
        foundCollection = collection;

        setState(() {
          _stockCount = stock is int ? stock : int.tryParse(stock.toString()) ?? 0;
        });
        return;
      }
    }
    print("Product not found in any collection.");
  }

  Future<void> reduceStock(int quantity) async {
    if (foundCollection == null) {
      print("No collection found for this product.");
      return;
    }

    final newStock = _stockCount - quantity;
    if (newStock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not enough stock available")),
      );
      return;
    }

    try {
      // Update stock in the product collection
      await FirebaseFirestore.instance
          .collection(foundCollection!)
          .doc(widget.productId)
          .update({'stock': newStock});

      setState(() {
        _stockCount = newStock;
      });

      // Add or update the item in ReviewCart
      final reviewCartRef = FirebaseFirestore.instance.collection("ReviewCart").doc(widget.productId);
      final existingCartItem = await reviewCartRef.get();

      if (existingCartItem.exists) {
        final currentQty = existingCartItem.data()?['productQuantity'] ?? 0;
        await reviewCartRef.update({
          'productQuantity': currentQty + quantity,
        });
      } else {
        await reviewCartRef.set({
          'cartId': widget.productId,
          'productId': widget.productId,
          'productName': productData['productName'],
          'productImage': productData['productImage'],
          'productPrice': productData['productPrice'],
          'productQuantity': quantity,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item added to cart!")),
      );
    } catch (e) {
      print("Error updating stock or cart: $e");
    }
  }

  String getStockMessage(int stockCount) {
    if (stockCount == 0) return "Out of Stock";
    if (stockCount > 50) return "Available";
    if (stockCount > 10) return "Only Few Left";
    return "Low Stock";
  }

  Color getStatusColor(int stockCount) {
    if (stockCount == 0) return Colors.red;
    if (stockCount > 50) return Colors.green;
    if (stockCount > 10) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  void initState() {
    super.initState();
    loadStock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.productName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Stock: $_stockCount", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Text(getStockMessage(_stockCount), style: TextStyle(color: getStatusColor(_stockCount))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => reduceStock(1),
              child: const Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../../config/colors.dart';
//
// class StockPage extends StatefulWidget {
//   final String productId;
//   final String productName;
//
//   const StockPage({
//     required this.productId,
//     required this.productName,
//     super.key,
//   });
//
//   @override
//   State<StockPage> createState() => _StockPageState();
// }
//
// class _StockPageState extends State<StockPage> {
//   final List<String> collections = ['FruitsProduct', 'GrainsProduct', 'VegetablesProduct'];
//
//   int _stockCount = 0;
//   String? foundCollection;
//
//   Future<void> loadStock() async {
//     for (String collection in collections) {
//       final doc = await FirebaseFirestore.instance
//           .collection(collection)
//           .doc(widget.productId)
//           .get();
//
//       if (doc.exists && doc.data() != null) {
//         final data = doc.data()!;
//         final stock = data['stock'];
//         foundCollection = collection;
//
//         setState(() {
//           _stockCount = stock is int ? stock : int.tryParse(stock.toString()) ?? 0;
//         });
//         return;
//       }
//     }
//     print("Product not found in any collection.");
//   }
//
//   Future<void> reduceStock(int quantity) async {
//     if (foundCollection == null) {
//       print("No collection found for this product.");
//       return;
//     }
//
//     final newStock = _stockCount - quantity;
//     if (newStock < 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Not enough stock available")),
//       );
//       return;
//     }
//
//     try {
//       await FirebaseFirestore.instance
//           .collection(foundCollection!)
//           .doc(widget.productId)
//           .update({'stock': newStock});
//
//       setState(() {
//         _stockCount = newStock;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Item added to cart!")),
//       );
//     } catch (e) {
//       print("Error updating stock: $e");
//     }
//   }
//
//   String getStockMessage(int stockCount) {
//     if (stockCount == 0) return "Out of Stock";
//     if (stockCount > 50) return "Available";
//     if (stockCount > 10) return "Only Few Left";
//     return "Low Stock";
//   }
//
//   Color getStatusColor(int stockCount) {
//     if (stockCount == 0) return Colors.red;
//     if (stockCount > 50) return Colors.green;
//     if (stockCount > 10) return Colors.orange;
//     return Colors.redAccent;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadStock();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final statusColor = getStatusColor(_stockCount);
//     final stockMessage = getStockMessage(_stockCount);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${widget.productName} Stock"),
//         backgroundColor: primaryColor,
//       ),
//       body: _stockCount == 0
//           ? const Center(child: CircularProgressIndicator())
//           : Center(
//         child: Card(
//           elevation: 6,
//           margin: const EdgeInsets.all(24),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.inventory_2_rounded,
//                   color: statusColor,
//                   size: 60,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   "Stock: $_stockCount",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: statusColor),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   stockMessage,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton.icon(
//                   onPressed: () => reduceStock(1), // You can pass custom quantity here
//                   icon: const Icon(Icons.add_shopping_cart),
//                   label: const Text("Add to Cart"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryColor,
//                     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                     textStyle: const TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
