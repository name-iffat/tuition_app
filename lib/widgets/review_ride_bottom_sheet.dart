import 'package:flutter/material.dart';


Widget reviewRideBottomSheet(
    BuildContext context, num distance, num duration) {

  return Positioned(
    bottom: 0,
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    tileColor: Colors.grey[100],
                    leading: const Image(
                        image: AssetImage('images/LOGO.png'),
                        height: 50,
                        width: 50),
                    title: const Text('To Tutee',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('${distance.toStringAsFixed(2)}kms, ${duration.toStringAsFixed(2)} mins'),

                  ),
                ),
              ]),
        ),
      ),
    ),
  );
}