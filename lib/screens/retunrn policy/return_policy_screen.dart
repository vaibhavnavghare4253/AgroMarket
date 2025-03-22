import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReturnPolicyScreen extends StatefulWidget {
  @override
  _ReturnPolicyScreenState createState() => _ReturnPolicyScreenState();
}

class _ReturnPolicyScreenState extends State<ReturnPolicyScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  Future<void> submitReturnRequest() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection("return_requests").add({
          "userId": user.uid,
          "email": user.email,
          "productName": productNameController.text,
          "orderId": orderIdController.text,
          "reason": reasonController.text,
          "status": "Pending",  // Default status
          "timestamp": FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Return request submitted successfully!")),
        );

        Navigator.pop(context); // Go back after submission
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You need to be logged in to request a return.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Return Policy"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Request a Product Return",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              SizedBox(height: 20),

              TextFormField(
                controller: productNameController,
                decoration: InputDecoration(labelText: "Product Name"),
                validator: (value) =>
                value!.isEmpty ? "Please enter product name" : null,
              ),

              TextFormField(
                controller: orderIdController,
                decoration: InputDecoration(labelText: "Order ID"),
                validator: (value) =>
                value!.isEmpty ? "Please enter order ID" : null,
              ),

              TextFormField(
                controller: reasonController,
                decoration: InputDecoration(labelText: "Reason for Return"),
                maxLines: 3,
                validator: (value) =>
                value!.isEmpty ? "Please provide a reason" : null,
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: submitReturnRequest,
                child: Text("Submit Request"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
