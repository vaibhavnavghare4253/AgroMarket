class ProductModel {
  String productId;
  String productName;
  String productImage;
  int productPrice;
  int? productQuantity;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    this.productQuantity,
  });

  // Factory constructor to create an instance from Firestore data
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      productId: id,
      productName: data['productName'] ?? '',
      productImage: data['productImage'] ?? '',
      productPrice: data['productPrice'] ?? 0,
      productQuantity: data['productQuantity'] ?? 1,
    );
  }

  // Convert object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'productQuantity': productQuantity ?? 1,
    };
  }
}
