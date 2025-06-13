import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:uber_shop_app/provider/cart_provider.dart';
import 'package:uber_shop_app/provider/selected_size_provider.dart';
import 'package:uber_shop_app/views/screens/inner_screens/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({
    required this.productData,
    super.key,
  });

  final dynamic productData;

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int imgIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productReviewStream = _firestore
        .collection('productReviews')
        .where('productId', isEqualTo: widget.productData['productId'])
        .snapshots();
    final cartProv = ref.read(cartProvider.notifier);
    ref.watch(cartProvider);
    final isInCart =
        cartProv.getCartItems.containsKey(widget.productData['productId']);
    final selectedSizeProv = ref.read(selectedSizeProvider.notifier);
    final selectedSize = ref.watch(selectedSizeProvider);

    void callVendor(String phoneNumber) async {
      final String url = 'tel:$phoneNumber';
      if (await canLaunchUrl(Uri.parse(url))) {
        try {
          await launchUrl(Uri.parse(url));
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        throw ('Could not launch the call');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productData['productName'] ?? 'Product Details',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Thumbnail Section
            Stack(
              children: [
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    widget.productData['productImagesUrls'][imgIndex] ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productData['productImagesUrls'].length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() => imgIndex = index);
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.pink, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(
                              widget.productData['productImagesUrls'][index] ??
                                  '',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Product Details Section
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                widget.productData['productName'] ?? 'N/A',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                '\$ ${widget.productData['productPrice'].toStringAsFixed(2) ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Row(
                children: [
                  const Text(
                    'Total reviews: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),
                  Text(
                    widget.productData['rating'].toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    ' (${widget.productData['totalReviews'].toString()} Reviews)',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                'Available quantity: ${widget.productData['productQuantity'] ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ExpansionTile(
              title: Text(
                'Sizes available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade900,
                ),
              ),
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: widget.productData['sizeList'].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedSizeProv.getSelectedSize ==
                          widget.productData['sizeList'][index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: () {
                            isSelected = !isSelected;
                            final newSelected =
                                widget.productData['sizeList'][index];
                            selectedSizeProv.setSelectedSize(newSelected);
                          },
                          child: Chip(
                            label: Text(
                              widget.productData['sizeList'][index] ?? 'N/A',
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected == true
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            backgroundColor: isSelected == true
                                ? Colors.pink.shade100
                                : Colors.grey.shade200,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                'Product Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade900,
                ),
              ),
              children: [
                Text(
                  '${widget.productData['productDescription']}',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
              ],
            ),

            // Vendor Details Section
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Store Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  widget.productData['storeImage'] ?? '',
                ),
              ),
              title: Text(
                widget.productData['businessName'] ?? 'Unknown Store',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: InkWell(
                onTap: () {
                  //TODO: Go to verdor profile page
                },
                child: const Text(
                  'See profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Rating Section
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: RatingSummary(
                counter: widget.productData['totalReviews'],
                average: double.parse(widget.productData['rating'].toString()),
                showAverage: true,
                counterFiveStars: 5,
                counterFourStars: 4,
                counterThreeStars: 2,
                counterTwoStars: 1,
                counterOneStars: 1,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: productReviewStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return SizedBox(
                  height: 80.0 * snapshot.data!.size,
                  child: ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        final reviewData = snapshot.data!.docs[index];
                        return Card(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                child: Image.network(reviewData['buyerImage']),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(reviewData['buyerName']),
                                  Text(reviewData['review']),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                );
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: isInCart
                  ? null
                  : () {
                      cartProv.addToCart(
                        widget.productData['productId'],
                        selectedSize,
                        1, // quantity in the cart
                        widget.productData,
                      );
                    },
              label: Text(
                isInCart ? 'Already in cart' : 'Add to cart',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isInCart ? Colors.white : Colors.pink,
                ),
              ),
              icon: Icon(
                CupertinoIcons.shopping_cart,
                color: isInCart ? Colors.white : Colors.pink,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      vendorId: widget.productData['vendorId'],
                      buyerId: _auth.currentUser!.uid,
                      productId: widget.productData['productId'],
                      productName: widget.productData['productName'],
                    ),
                  ),
                );
              },
              icon: const Icon(
                CupertinoIcons.chat_bubble,
                color: Colors.pink,
              ),
            ),
            IconButton(
              onPressed: () {
                callVendor(widget.productData['phoneNumber']);
              },
              icon: const Icon(
                CupertinoIcons.phone,
                color: Colors.pink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
