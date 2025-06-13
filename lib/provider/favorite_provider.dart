import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_shop_app/models/favorite_model.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteProvider, Map<String, FavoriteModel>>(
  (ref) => FavoriteProvider(),
);

class FavoriteProvider extends StateNotifier<Map<String, FavoriteModel>> {
  FavoriteProvider() : super({});

  void addToFavorite(
    String productId,
    int quantity,
    QueryDocumentSnapshot<Object?> productData,
  ) {
    state[productId] = FavoriteModel(
      productId: productId,
      quantity: quantity,
      productData: productData,
    );

    // notify listeners about the state change
    state = {...state};
  }

  void removeFromFavorite(String productId) {
    /** Remove the product from the favorite if it exists */
    if (state.containsKey(productId)) {
      final updatedFavorite = Map<String, FavoriteModel>.from(state);
      updatedFavorite.remove(productId);
      state = updatedFavorite;
    }
  }

  void clearFavorite() {
    state.clear();
    // notify listeners about the state change
    state = {...state};
  }

  Map<String, FavoriteModel> get getFavoriteItem => state;
}
