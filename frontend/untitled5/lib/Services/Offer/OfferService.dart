import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import the package

import '../../Model/offer/Category.dart';
import '../../Model/offer/offer.dart';
import '../env.dart';

//addOFfer
Future<void> addOffre(String titre, String address, double prix, String description, List<File> files, List<Category> categories) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage(); // Initialize the instance
  String? email = await secureStorage.read(key: 'email');
  String? password = await secureStorage.read(key: 'password');
  try {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$email:$password'));

    var request = http.MultipartRequest('POST', Uri.parse(VPNURL + 'services/addService'));
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = basicAuth;
    request.headers['Accept'] = 'application/json';

    // Add form fields
    request.fields.addAll({
      'service': jsonEncode({
        "titre": titre,
        "price": prix,
        "description": description,
        "adresse": address,
        "categories": categories.map((category) => category.toJson()).toList(),
        // Add other fields if needed
      }),
    });

    // Add images
    for (var i = 0; i < files.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        files[i].path,
      ));
    }

    // Send the request
    http.StreamedResponse response = await request.send();
    print('Number of images: ${files.length}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      // If the server returns a 201 CREATED or 200 OK response, handle the success here.
      // You might want to parse the response if the server sends any meaningful data.
      Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      // If the server did not return a 201 CREATED or 200 OK response,
      // throw an exception and handle the failure.
      print('Failed with status code: ${response.statusCode}');
      print('Failed with: ${request.fields}');

      Fluttertoast.showToast(
        msg: "Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } catch (error) {
    // Handle any exceptions that might occur during the HTTP request.
    print('Error: $error');
    if (error is http.Response) {
      print('Response body: ${error.body}');
    }

    throw Exception('Failed to create annonce.');
  }
}

//getalloffers
Future <List<Offer>> fetchOffers()async{

 final response = await http.get(
    Uri.parse(VPNURL+'services'),
    headers: {
     // 'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
    List<Offer> categories = jsonData.map((json) => Offer.fromJson(json)).toList();
    print(jsonData.length);

    return categories;
  } else {
    throw Exception("Can't get the value");
  }

}







//getOfferById
Future<Offer?> getOfferById(int offerId) async {
  try {
    final response = await http.get(
      Uri.parse(VPNURL + 'services/$offerId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(utf8.decode(response.bodyBytes));
      Offer offer = Offer.fromJson(jsonData);
      return offer;
    } else {
      throw Exception("Can't get the offer");
    }
  } catch (error) {
    print('Error: $error');
    throw Exception("Can't get the offer");
  }
}


//getalloffersofuser
Future <List<Offer>> fetchOffersUser()async{

  final FlutterSecureStorage secureStorage = FlutterSecureStorage(); // Initialize the instance

  String? email = await secureStorage.read(key: 'email');
  String? password = await secureStorage.read(key: 'password');
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('$email:$password'));


  final response = await http.get(
    Uri.parse(VPNURL+'services/UserServices'),
    headers: {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
    List<Offer> offers = jsonData.map((json) => Offer.fromJson(json)).toList();
    // Print the JSON data for debugging

    return offers;
  } else {
    throw Exception("Can't get the value");
  }

}

//deleteOffer
Future<void> deleteOffer(int id) async {

  try {
    final response = await http.delete(Uri.parse(VPNURL + 'services/$id'));

    if (response.statusCode == 200) {
      print('Suppression réussie');
    } else {
      print('Échec de la suppression. Statut ${response.statusCode}');
    }
  } catch (error) {
    print('Erreur lors de la suppression: $error');
  }
}
//update


Future<void> updateOffer(Offer offer ,List<File> imageFiles) async {
  int? id = offer.idService;

  final url = Uri.parse(VPNURL + 'services/$id'); // Replace with your actual endpoint
  try {
    final http.MultipartRequest request = http.MultipartRequest('PUT', url);

    // Convert Offer object to JSON and attach it as a field
    request.fields['service'] = json.encode(offer.toJson());
    print("update fi service");
    print('Offer JSON: ${json.encode(offer.toJson())}');

    // Attach the images as parts
    for (int i = 0; i < imageFiles.length; i++) {
      final imageFile = imageFiles[i];
      request.files.add(
        await http.MultipartFile.fromPath('images', imageFile.path),
      );
    }

    // Send the request
    final http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "succés",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Offer updated successfully');
    } else {
      print('Failed to update offer. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    Fluttertoast.showToast(
      msg: "échec",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    print('Error updating offer: $error');
  }
}



//getOffersBycategory
Future<List<Offer>> getOffersByCategory(String categoryName) async {
  try {
    // Récupérer toutes les offres
    List<Offer> allOffers = await fetchOffers();

    // Filtrer les offres par catégorie
    List<Offer> filteredOffers = allOffers
        .where((offer) => offer.category?.any((cat) => cat.name == categoryName) ?? false)
        .toList();

    return filteredOffers;
  } catch (error) {
    print('Error: $error');
    throw Exception("Can't get offers for the category");
  }
}









