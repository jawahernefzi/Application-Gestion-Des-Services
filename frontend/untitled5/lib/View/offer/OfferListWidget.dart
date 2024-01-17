import 'package:flutter/material.dart';
import '../../Model/offer/offer.dart';
import '../../Services/Offer/OfferService.dart';
import 'UpdateOfferScreen.dart';

class OfferListWidget extends StatefulWidget {
  @override
  _OfferListWidgetState createState() => _OfferListWidgetState();
}

class _OfferListWidgetState extends State<OfferListWidget> {
  Future<List<Offer>>? _offersFuture;

  @override
  void initState() {
    super.initState();
    _offersFuture = fetchOffersUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mes services',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        backgroundColor: Colors.white60,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _offersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<Offer> offers = snapshot.data as List<Offer>;

              return RefreshIndicator(
                onRefresh: () async {
                  await _refreshOffers();
                },
                child: ListView.builder(
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateOfferScreen(offer: offers[index]),
                            ),
                          );
                        },
                        title: Text(
                          offers[index].titre.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete,color:Colors.teal),
                          onPressed: () {
                            showDeleteConfirmationDialog(context, offers[index]);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _refreshOffers() async {
    setState(() {
      _offersFuture = fetchOffersUser();
    });
  }

  void showDeleteConfirmationDialog(BuildContext context, Offer offer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer cette offre: ${offer.titre}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Annuler', style: TextStyle(
                fontSize: 14.0,
                color: Colors.teal,
                fontWeight: FontWeight.bold,

              ),),

            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await deleteOffer(offer.idService!.toInt());
                await _refreshOffers(); // Refresh the offers after deletion
              },
              child: Text('Supprimer', style: TextStyle(
                fontSize: 14.0,
                color: Colors.teal,
                fontWeight: FontWeight.bold,

              ),),
            ),
          ],
        );
      },
    );
  }
}
