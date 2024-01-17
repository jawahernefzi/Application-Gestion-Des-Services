import '../../Model/user.dart';
import '../../Services/user/UserService.dart';
import 'Login.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: Text('Inscription'),
        ),
        body: Container(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  color: Colors.white,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Créez un compte',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(labelText: 'Nom'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Le nom est requis';
                                } else if (value.length > 10) {
                                  return 'Le nom ne doit pas dépasser 10 caractères';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(labelText: 'Prénom'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Le prénom est requis';
                                } else if (value.length > 10) {
                                  return 'Le prénom ne doit pas dépasser 10 caractères';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'L\'email est requis';
                                } else if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'Veuillez saisir une adresse email valide';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(labelText: 'Mot de passe'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Le mot de passe est requis';
                                } else if (value.length < 8 || value.length > 14) {
                                  return 'Le mot de passe doit avoir entre 8 et 14 caractères';
                                } else if (!RegExp(r"^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$")
                                    .hasMatch(value)) {
                                  return 'Le mot de passe doit contenir des chiffres et des lettres';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 32.0),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String firstName = _firstNameController.text;
                                  String lastName = _lastNameController.text;
                                  String email = _emailController.text;
                                  String password = _passwordController.text;
                                  String u = await register(firstName,lastName,email,password);
                                  print("registre");
                                  print(u);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                  );

                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                              ),
                              child: Text('S\'inscrire',   style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
        )
    );
  }
}
