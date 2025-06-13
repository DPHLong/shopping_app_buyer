import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_shop_app/views/screens/main_screen.dart';
import 'package:uber_shop_app/widgets/rounded_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late Position _currentPosition;
  late GoogleMapController mapController;

  getUserCurrentLocation() async {
    try {
      await Geolocator.checkPermission();
      await Geolocator.requestPermission();

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: true,
      );
      LatLng latLng =
          LatLng(_currentPosition.latitude, _currentPosition.longitude);
      CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16);
      mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Map Screen', style: TextStyle(color: Colors.white)),
      //   backgroundColor: Colors.pink,
      // ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            padding: const EdgeInsets.only(bottom: 100),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
              getUserCurrentLocation();
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: RoundedIconButton(
              label: 'SHOP NOW',
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () => Get.offAll(const MainScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
