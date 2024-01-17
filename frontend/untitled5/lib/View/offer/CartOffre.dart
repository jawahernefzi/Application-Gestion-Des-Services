import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../Model/offer/offer.dart';

class CartOffre extends StatefulWidget {
  final Offer? offer;

  const CartOffre({Key? key, this.offer}) : super(key: key);

  @override
  State<CartOffre> createState() => _CartOffreState();
}

class _CartOffreState extends State<CartOffre> {
  @override
  Widget build(BuildContext context) {
    Uint8List? firstImageBytes = widget.offer!.images?[0].url;

    return Card(
      color: Colors.white,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (firstImageBytes != null)
            Image.memory(
              firstImageBytes,
              height: 100.0, // Adjust the height as needed
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.offer?.titre ?? "",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      "à partir de ",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      (widget.offer?.price?.toInt().toString() ?? "") ,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    Text(
                      "TND",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
