import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uber_shop_app/provider/cart_provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  String formatedDate(DateTime date) {
    final outputDateFormat = DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
    return outputDateFormat;
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = ref.read(cartProvider.notifier); // access function
    final cartData = ref.watch(cartProvider); // interact with data
    double totalPrice = cartProv.calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: cartData.length,
        itemBuilder: (context, index) {
          final cartItem = cartData.values.toList()[index];
          return Card(
            elevation: 4,
            child: Row(
              children: [
                const SizedBox(width: 8),
                Image.network(
                  cartItem.productData['productImagesUrls'][0],
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.productData['productName'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('Size: ${cartItem.productSize}'),
                    Text(
                      '${cartItem.quantity} x \$${cartItem.productData['productPrice'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.pink,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () async {
          setState(() => isLoading = true);
          final buyerDoc = await _firestore
              .collection('buyers')
              .doc(_auth.currentUser!.uid)
              .get();
          cartProv.getCartItems.forEach((key, item) async {
            // upload order to database
            final orderId = const Uuid().v4();
            await _firestore.collection('orders').doc(orderId).set({
              'orderId': orderId,
              'productId': item.productId,
              'productName': item.productData['productName'],
              'quantity': item.quantity,
              'productSize': item.productSize,
              'productImage': item.productData['productImagesUrls'][0],
              'productPrice': item.productData['productPrice'],
              'totalPrice': item.quantity * item.productData['productPrice'],
              'buyerId': _auth.currentUser!.uid,
              'fullName': (buyerDoc.data() as Map<String, dynamic>)['fullName'],
              'email': (buyerDoc.data() as Map<String, dynamic>)['email'],
              'buyerImage':
                  (buyerDoc.data() as Map<String, dynamic>)['profileImage'],
              'vendorId': item.productData['vendorId'],
              'vendorName': item.productData['businessName'],
              'cityValue': item.productData['cityValue'],
              'countryValue': item.productData['countryValue'],
              'vendorImage': item.productData['storeImage'],
              'accepted': false,
              'orderDate': formatedDate(DateTime.now()),
            }).whenComplete(() {
              setState(() => isLoading = false);
            });
          });
        },
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                'PLACE ORDER \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
      ),
    );
  }
}
