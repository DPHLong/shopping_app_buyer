import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_shop_app/models/cart_model.dart';

final cartProvider =
    StateNotifierProvider<CartProvider, Map<String, CartModel>>(
  (ref) => CartProvider(),
);

class CartProvider extends StateNotifier<Map<String, CartModel>> {
  CartProvider() : super({});

  void addToCart(
    String productId,
    String productSize,
    int quantity,
    QueryDocumentSnapshot<Object?> productData,
  ) {
    /** Check if the product already exists in the cart
    * If it does, increment the quantity
    * If it doesn't, add a new CartModel to the state 
    */
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: CartModel(
          productId: state[productId]!.productId,
          productSize: state[productId]!.productSize,
          quantity: state[productId]!.quantity + 1,
          productData: state[productId]!.productData,
        ),
      };
    } else {
      state = {
        ...state,
        productId: CartModel(
          productId: productId,
          productSize: productSize,
          quantity: quantity,
          productData: productData,
        ),
      };
    }
  }

  void removeFromCart(String productId) {
    /** Remove the product from the cart if it exists */
    if (state.containsKey(productId)) {
      final updatedCart = Map<String, CartModel>.from(state);
      updatedCart.remove(productId);
      state = updatedCart;
    }
  }

  void increaseQuantity(String productId) {
    /** Increase the product's quantity by 1 */
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;
      // notify listeners about the state change
      state = {...state};
    }
  }

  void decreaseQuantity(String productId) {
    /** Increase the product's quantity by 1 */
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;
      // notify listeners about the state change
      state = {...state};
    }
  }

  void clearCart() {
    state.clear();
    // notify listeners about the state change
    state = {...state};
  }

  double calculateTotalPrice() {
    double total = 0.0;
    state.forEach((productId, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  Map<String, CartModel> get getCartItems => state;
}
