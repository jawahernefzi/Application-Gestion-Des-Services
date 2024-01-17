
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Model/user.dart';
import '../env.dart';
import 'dart:io';


//user registre
Future <String> register (firstName,lastName,email,password) async{
final response = await http.post(
  Uri.parse(VPNURL + "MyUser/addUser"),
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(<String, dynamic>{
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password
  }),
);

if (response.statusCode == 201 || response.statusCode == 200) {
  // If the server did return a 201 CREATED response,
  // then parse the JSON.
print(response.body);

  return "success";
} else if(response.statusCode == 500){
  Fluttertoast.showToast(
      msg: "email existe déja ",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);

  throw Exception('Failed to create account .');

}
else {
 // var mess = jsonDecode(response.body)['message'];
 // print(mess.runtimeType);
  // If the server did not return a 201 CREATED response,
  // then throw an exception.

  print("not logged");
  Fluttertoast.showToast(
      msg: "Probléme de registre ",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);

  throw Exception('Failed to create account .');
}

}
//login
Future<User> authenticateUser(String email, String password) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final response = await http.post(
    Uri.parse(VPNURL + 'api/auth'), // Remplacez par l'URL réelle de votre API
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': email,
      'password': password
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.

    User u = User.fromJson(jsonDecode(response.body));
    print(jsonDecode(response.body));
    //secureStorage stocké l'email et password
    await secureStorage.write(key: 'email', value: email);
    await secureStorage.write(key: 'password', value: password);
    print(u);
    return u;
  } else {
    // var mess = jsonDecode(response.body)['message'];
    // print(mess.runtimeType);
    // If the server did not return a 201 CREATED response,
    // then throw an exception.

    print("not logged");
    Fluttertoast.showToast(
        msg: "email ou mot de passe incorrecte  ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    throw Exception('Failed to create account .');
  }

}

//getuserbyemail
Future<User> getUserByEmail() async {
  try {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? email = await secureStorage.read(key: 'email');

    final response = await http.get(
      Uri.parse("${VPNURL}MyUser/email/$email"),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );
    print('Response Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(utf8.decode(response.bodyBytes));
      User user = User.fromJson(jsonData);
      print("byemail");
      print(user.role?.roleName);

      return user;
    } else {
      throw Exception("Failed to load user. Status Code: ${response.statusCode}");
    }
  } catch (error) {
    print('Error: $error');
    throw Exception("Failed to load user");
  }
}



//getUserById
Future<User> getUserById(int userId) async {
  try {
    final response = await http.get(Uri.parse("${VPNURL}MyUser/$userId"));



    if (response.statusCode == 200) {
      // Specify the encoding when decoding the response body
      return User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load user');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Failed to load user');
  }
}

//getAllUsers
Future<List<User>> getUsers() async {
  final response = await http.get(Uri.parse('$VPNURL/getUsers'));

  if (response.statusCode == 200) {
    Iterable users = jsonDecode(response.body);
    return List<User>.from(users.map((user) => User.fromJson(user)));
  } else {
    throw Exception('Failed to load users');
  }
}
//UpdateUser
Future<void> updateUser(User user ,List<File> imageFiles, File profileImage) async {
  int? id = user.id;

  final url = Uri.parse(VPNURL + 'MyUser/$id'); // Replace with your actual endpoint
  try {
    final http.MultipartRequest request = http.MultipartRequest('PUT', url);

    // Convert user object to JSON and attach it as a field
    request.fields['user'] = json.encode(user.toJson());
    print("update user ");
    print('Offer JSON: ${json.encode(user.toJson())}');

    // Attach the images as parts
    for (int i = 0; i < imageFiles.length; i++) {
      final imageFile = imageFiles[i];
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
    }
    // Add profile image as a file
    request.files.add(
      await http.MultipartFile.fromPath(
        'profil',
        profileImage.path,
      ),
    );


    // Send the request
    final http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "succès",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.teal,
          textColor: Colors.white,
          fontSize: 16.0);
      print('user updated successfully');
    } else {

      print('Failed to update user. Status code: ${response.statusCode}');
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
        fontSize: 16.0);
    print('Error updating user: $error');
  }
}












//logout
void logout() {
  // 1. Clear the stored token
  clearAuthToken();

}
void clearAuthToken() {
  // Clear the authentication token from local storage or cookies
  // For example, in Flutter/Dart using shared_preferences package:
  SharedPreferences.getInstance().then((prefs) {
    prefs.remove('accessToken');
  });
}



