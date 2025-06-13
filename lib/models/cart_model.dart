import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String productId;
  final String productSize;
  int quantity; // Quantity in the cart
  final QueryDocumentSnapshot<Object?> productData;

  CartModel({
    required this.productId,
    required this.productSize,
    required this.quantity,
    required this.productData,
  });

  double get totalPrice =>
      quantity * double.parse(productData['productPrice'].toString());
}
