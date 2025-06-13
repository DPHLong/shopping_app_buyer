import 'package:flutter/material.dart';
import 'package:uber_shop_app/views/screens/widgets/banner_widget.dart';
import 'package:uber_shop_app/views/screens/widgets/category_item_widget.dart';
import 'package:uber_shop_app/views/screens/widgets/category_text_widget.dart';
import 'package:uber_shop_app/views/screens/widgets/home_product.dart';
import 'package:uber_shop_app/views/screens/widgets/location_widget.dart';
import 'package:uber_shop_app/views/screens/widgets/men_products_widget.dart';
import 'package:uber_shop_app/views/screens/widgets/reuse_text.dart';
import 'package:uber_shop_app/views/screens/widgets/women_products_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationWidget(),
            SizedBox(height: 20),
            BannerWidget(),
            SizedBox(height: 10),
            CategoryItemWidget(), // can switch with CategoryTextWidget
            SizedBox(height: 10),
            ReuseText(title: "Home products", subtitle: 'Wipe to see more'),
            HomeProduct(),
            SizedBox(height: 10),
            ReuseText(title: "Men's products", subtitle: 'Wipe to see more'),
            MenProductsWidget(),
            SizedBox(height: 10),
            ReuseText(title: "Women's products", subtitle: 'Wipe to see more'),
            WomenProductsWidget(),
          ],
        ),
      ),
    );
  }
}
