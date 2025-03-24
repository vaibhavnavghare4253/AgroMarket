import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen/drawer_side.dart';
 // Import the drawer widget

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _collections = [
    'FruitsProduct',
    'GrainsProduct',
    'VegetablesProduct'
  ];

  String _selectedCollection = 'FruitsProduct';

  void _addProduct() {
    String name = _nameController.text.trim();
    double? price = double.tryParse(_priceController.text.trim());
    String imageUrl = _imageUrlController.text.trim();

    if (name.isNotEmpty && price != null && imageUrl.isNotEmpty) {
      _firestore.collection(_selectedCollection).add({
        'productName': name,
        'productPrice': price,
        'productImage': imageUrl,
      }).then((documentReference) {
        _firestore.collection(_selectedCollection).doc(documentReference.id).update({
          'productId': documentReference.id,
        });

        _nameController.clear();
        _priceController.clear();
        _imageUrlController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product added successfully!')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding product: $error')));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields correctly.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      // drawer: DrawerSide(), // Add the drawer here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedCollection,
              items: _collections.map((String collection) {
                return DropdownMenuItem<String>(
                  value: collection,
                  child: Text(collection),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCollection = newValue;
                  });
                }
              },
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Product Price'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Product Image URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
