import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  final String productId;
  final int quantity; // Quantity in the cart
  final QueryDocumentSnapshot<Object?> productData;

  FavoriteModel({
    required this.productId,
    required this.quantity,
    required this.productData,
  });

  // @override
  // String toString() {
  //   return 'FavoriteModel(id: $productId, title: $productName, quantity: $quantity, price: $productPrice)';
  // }
}
