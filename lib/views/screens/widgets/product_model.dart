import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_shop_app/provider/favorite_provider.dart';
import 'package:uber_shop_app/views/screens/inner_screens/product_detail_screen.dart';

class ProductModel extends ConsumerStatefulWidget {
  const ProductModel({
    super.key,
    required this.productData,
  });

  final QueryDocumentSnapshot<Object?> productData;

  @override
  _ProductModelState createState() => _ProductModelState();
}

class _ProductModelState extends ConsumerState<ProductModel> {
  @override
  Widget build(BuildContext context) {
    final favoriteProv = ref.read(favoriteProvider.notifier);
    ref.watch(favoriteProvider);
    final isInFavorite = favoriteProv.getFavoriteItem.containsKey(
      widget.productData['productId'],
    );

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailScreen(productData: widget.productData);
        }));
      },
      child: Card(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                fit: BoxFit.cover,
                height: 50,
                widget.productData['productImagesUrls'][0] ?? '',
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productData['productName'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$ ${widget.productData['productPrice'].toStringAsFixed(2) ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade900,
                  ),
                  softWrap: false,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    Text(widget.productData['rating'].toString()),
                  ],
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: isInFavorite == true
                  ? () {
                      favoriteProv
                          .removeFromFavorite(widget.productData['productId']);
                    }
                  : () {
                      favoriteProv.addToFavorite(
                        widget.productData['productId'],
                        1,
                        widget.productData,
                      );
                    },
              icon: Icon(
                isInFavorite == true
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: Colors.pink.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
