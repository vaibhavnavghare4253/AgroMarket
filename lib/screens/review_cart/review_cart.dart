import 'package:agri_market/config/colors.dart';
import 'package:agri_market/models/review_cart_model.dart';
import 'package:agri_market/providers/review_cart_provider.dart';
import 'package:agri_market/screens/check_out/dilevery_details/dilevery_delails.dart';
import 'package:agri_market/widgets/single_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ReviewCart extends StatelessWidget {
  late ReviewCartProvider reviewCartProvider;

  showAlertDialog(BuildContext context, ReviewCartModel delete) {
    // Alert dialog buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        reviewCartProvider.reviewCartDataDelete(delete.cartId);
        Navigator.of(context).pop();
      },
    );

    // Set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cart Product"),
      content: Text("Do you want to delete this product?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    reviewCartProvider = Provider.of<ReviewCartProvider>(context);
    reviewCartProvider.getReviewCartData();

    return Scaffold(
      bottomNavigationBar: ListTile(
        title: Text("Total Amount"),
        subtitle: Text(
          "\₹ ${reviewCartProvider.getTotalPrice()}",
          style: TextStyle(
            color: Colors.green[900],
          ),
        ),
        trailing: Container(
          width: 160,
          child: MaterialButton(
            child: Text("Proceed"),
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () {
              if (reviewCartProvider.getReviewCartDataList.isEmpty) {
                Fluttertoast.showToast(msg: "Cart is Empty");
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DeliveryDetails()),
              );
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Review Cart",
          style: TextStyle(color: textColor, fontSize: 18),
        ),
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
      ),
      body: reviewCartProvider.getReviewCartDataList.isEmpty
          ? Center(
        child: Lottie.asset(
          'assets/emptycart.json', // Animation for empty cart
          fit: BoxFit.contain,
        ),
      )
          : ListView.builder(
        itemCount: reviewCartProvider.getReviewCartDataList.length,
        itemBuilder: (context, index) {
          ReviewCartModel data =
          reviewCartProvider.getReviewCartDataList[index];
          return Column(
            children: [
              SizedBox(height: 10),
              SingleItem(
                isBool: true,
                wishList: false,
                productImage: data.cartImage,
                productName: data.cartName,
                productPrice: data.cartPrice,
                productId: data.cartId,
                productQuantity: data.cartQuantity,
                onDelete: () {
                  showAlertDialog(context, data);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
