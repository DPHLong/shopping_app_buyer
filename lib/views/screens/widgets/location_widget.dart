import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
      child: Row(
        children: [
          Image.asset('assets/icons/store-1.png', width: 30),
          const SizedBox(width: 15),
          Image.asset('assets/icons/pickicon.png', width: 30),
          const SizedBox(width: 8),
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Current Location',
                labelText: 'Current Location',
                // border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
