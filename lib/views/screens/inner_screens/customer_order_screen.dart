import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({super.key});

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _reviewController = TextEditingController();
  double rating = 0.0;

  Widget _ratingDialog(Map<String, dynamic> data, bool hasReviewed) {
    return AlertDialog(
      title: Text(hasReviewed ? 'Update review' : 'Leave a review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _reviewController,
            decoration: const InputDecoration(
              labelText: 'Your review',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: RatingBar.builder(
              initialRating: rating,
              itemCount: 5,
              minRating: 1,
              maxRating: 5,
              allowHalfRating: true,
              itemSize: 15,
              unratedColor: Colors.grey,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) {
                return const Icon(Icons.star, color: Colors.amber);
              },
              onRatingUpdate: (value) {
                rating = value;
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // if user has already rated this product, let him update it.
            // else create a new rating.
            final review = _reviewController.text;
            if (hasReviewed) {
              await _firestore
                  .collection('productReviews')
                  .doc(data['orderId'])
                  .update({
                'vendorId': data['vendorId'],
                'buyerId': data['buyerId'],
                'buyerName': data['fullName'],
                'buyerImage': data['buyerImage'],
                'productId': data['productId'],
                'rating': rating,
                'review': review,
              }).whenComplete(() {
                updateProductRating(data['productId']);
                Navigator.pop(context);
                _reviewController.clear();
              });
            } else {
              await _firestore
                  .collection('productReviews')
                  .doc(data['orderId'])
                  .set({
                'vendorId': data['vendorId'],
                'buyerId': data['buyerId'],
                'buyerName': data['fullName'],
                'buyerImage': data['buyerImage'],
                'productId': data['productId'],
                'rating': rating,
                'review': review,
              }).whenComplete(() {
                updateProductRating(data['productId']);
                Navigator.pop(context);
                _reviewController.clear();
              });
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Future<bool> hasUserReviewedProduct(String productId) async {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        final QuerySnapshot querySnapshot = await _firestore
            .collection('productReviews')
            .where('buyerId', isEqualTo: user.uid)
            .where('productId', isEqualTo: productId)
            .get();
        return querySnapshot.docs.isNotEmpty;
      }
    } catch (e) {
      debugPrint('--- Error by checking --- $e');
    }
    return false;
  }

  Future<void> updateProductRating(String productId) async {
    try {
      final querySnapshot = await _firestore
          .collection('productReviews')
          .where('productId', isEqualTo: productId)
          .get();
      double totalRating = 0;
      int totalReviews = querySnapshot.docs.length;

      for (var doc in querySnapshot.docs) {
        totalRating += doc['rating'];
      }
      final double averageRating =
          (totalReviews > 0) ? totalRating / totalReviews : 0;
      debugPrint('--- Rating --- $averageRating');
      await _firestore.collection('products').doc(productId).update({
        'rating': averageRating,
        'totalReviews': totalReviews,
      });
    } catch (e) {
      debugPrint('--- Error by checking --- $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> orderssStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: _auth.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orderssStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If no data was retrieved from a category:
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'You have no order',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: data['accepted'] == true
                          ? Icon(
                              Icons.delivery_dining,
                              color: Colors.green.shade300,
                              size: 40,
                            )
                          : Icon(
                              Icons.access_time,
                              color: Colors.pink.shade900,
                              size: 40,
                            ),
                    ),
                    title: Text(
                      data['productName'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade900,
                      ),
                    ),
                    subtitle: Text(
                      data['accepted'] == true
                          ? 'On delivery'
                          : 'Waiting for confirm',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: data['accepted'] == true
                            ? Colors.green.shade300
                            : Colors.pink.shade900,
                      ),
                    ),
                    trailing: Text(
                      '\$${data['totalPrice'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade900,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: const Text(
                      'View Order Details',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Card(
                        child: Column(
                          children: [
                            const Text(
                              'Seller info:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  child: Image.network(data['vendorImage']),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['vendorName']),
                                    Text(
                                        '${data['cityValue']} - ${data['countryValue']}'),
                                    const Text('Email:'),
                                  ],
                                )
                              ],
                            ),
                            const Divider(),
                            const Text(
                              'Product info:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  child: Image.network(data['productImage']),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Single price: \$${data['productPrice'].toStringAsFixed(2)}'),
                                    Text('Quantity: ${data['quantity']}'),
                                    Text(
                                        'Size: ${data['productSize'] ?? 'N/A'}'),
                                    Text(
                                      'Date of order: ${data['orderDate']}',
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    data['accepted'] == true
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              final productId =
                                                  data['productId'];
                                              final hasReviewed =
                                                  await hasUserReviewedProduct(
                                                      productId);
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return _ratingDialog(
                                                      data, hasReviewed);
                                                },
                                              );
                                            },
                                            child: const Text('Rate'))
                                        : const SizedBox(),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
