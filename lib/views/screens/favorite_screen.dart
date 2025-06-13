import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_shop_app/provider/favorite_provider.dart';
import 'package:uber_shop_app/views/screens/inner_screens/product_detail_screen.dart';
import 'package:uber_shop_app/views/screens/widgets/product_model.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteProv = ref.read(favoriteProvider.notifier); // access function
    final favoriteItems = ref.watch(favoriteProvider); // interact with data

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Wishlist',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          if (favoriteItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                favoriteProv.clearFavorite();
              },
            ),
        ],
      ),
      body: favoriteItems.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final wishData = favoriteItems.values.toList()[index];

                return ListTile(
                  leading: Image.network(
                    wishData.productData['productImagesUrls'].isNotEmpty
                        ? wishData.productData['productImagesUrls'][0]
                        : '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(wishData.productData['productName']),
                  subtitle: Text(
                    '\$${wishData.productData['productPrice'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      favoriteProv.removeFromFavorite(wishData.productId);
                    },
                    icon: const Icon(Icons.heart_broken, color: Colors.pink),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductDetailScreen(
                          productData: wishData.productData);
                    }));
                  },
                );
                // ProductModel(productData: wishData.productData);
              },
            )
          : const Center(
              child: Text(
                'No items in your wishlist',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}
