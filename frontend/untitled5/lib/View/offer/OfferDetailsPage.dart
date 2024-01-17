import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../Model/offer/offer.dart';
import '../../Model/user.dart';
import '../../Services/user/UserService.dart';
import '../User/ProfilePage.dart';
import 'package:intl/intl.dart';

class OfferDetailsPage extends StatelessWidget {
  final Offer offer;

  OfferDetailsPage({required this.offer});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(offer.titre ?? 'Offer Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            if (offer.images != null && offer.images!.isNotEmpty)
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offer.images!.length,
                  itemBuilder: (context, index) {
                    if (index < offer.images!.length) {
                      return Container(
                        width: 200,
                        margin: EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(offer.images![index].url ?? Uint8List(0)),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    } else {
                      return SizedBox.shrink(); // Return an empty widget if index is out of bounds
                    }
                  },
                ),
              ),

            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(' ${offer.price?.toInt() ?? 0} TND', style: TextStyle(fontSize: 18)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.date_range), // Icône de date

                    Text(' ${DateFormat('yyyy-MM-dd HH:mm').format(offer.date!) ?? 'No date available'}', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.location_on), // Icône d'adresse
                Text('${offer.adresse ?? 'No address available'}', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.category), // Icône de catégorie
                Text(' ${offer.category?[0].name ?? 'No category available'}', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Description:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(offer.description ?? 'No description available', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: ()  async {
                User? user = await getUserById(offer.user!.id!.toInt());

                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(user: user),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal, // Change the button color to green
              ),
              child: Text('réservez maintenant ', style: TextStyle(color: Colors.white, fontSize: 18),),



            ),
          ],
        ),
      ),
    );
  }
}
