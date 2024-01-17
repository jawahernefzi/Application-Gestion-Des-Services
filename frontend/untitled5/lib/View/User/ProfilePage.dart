import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/images.dart';
import '../../Model/user.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    List<Images>? listImages = user.images;
    Uint8List? profileImage;
    List<Uint8List> workImages = [];

    for (Images image in listImages!) {
      if (image.name!.startsWith("profile")) {
        profileImage = image.url;
      } else {
        workImages.add(image.url!);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil de ${user.lastName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container pour les détails de l'utilisateur
            // Container pour les détails de l'utilisateur
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo de profil
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.teal),
                      image: DecorationImage(
                        image:
                            MemoryImage(profileImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  // Détails de l'utilisateur
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(' ${user.firstName}', style: TextStyle(fontSize: 18)),
                      Text(' ${user.lastName}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8.0),
                      // Icône d'adresse et adresse
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.teal),
                          SizedBox(width: 8.0),
                          Text('${user.adresseTravail}', style: TextStyle(fontSize: 18)),
                        ],
                      ),

                    ],
                  ),
                  Spacer(), // Pour étirer l'espace disponible
                  // Icône de téléphone
                  IconButton(
                    icon: Icon(Icons.phone, color: Colors.teal),
                    onPressed: () {
                      _launchPhoneCall(user.tel.toString());
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.0),


            SizedBox(height: 16.0),
            // Container pour les diplômes
            Container(
              width:500,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      children: [  Icon(Icons.category), Text('${user.category?[0].name ?? 'Non spécifiée'}', style: TextStyle(fontSize: 18)),]
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Diplôme:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0), // Ajoutez un espacement entre "Diplôme" et la valeur réelle
                  Text(
                    '${user.diplome}',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Ajoutez ici la logique pour afficher les diplômes
                ],
              ),
            ),

            // Container pour les photos de travail
            SizedBox(height: 16.0),
            if (workImages.isNotEmpty)
              Container(
                height: 300.0, // Ajustez la hauteur selon vos besoins
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Photos de travail:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: workImages.map((image) => _buildWorkImage(image)).toList(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkImage(Uint8List image) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        height: 200.0, // Ajustez la hauteur selon vos besoins
        width: 200.0, // Ajustez la largeur selon vos besoins
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: MemoryImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _launchPhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Gérer le cas où l'ouverture de l'application de téléphone échoue
      print('Impossible d\'ouvrir l\'application de téléphone.');
    }
  }
}
