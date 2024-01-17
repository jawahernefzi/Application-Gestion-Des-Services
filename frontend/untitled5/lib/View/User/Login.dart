import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/user/UserService.dart';
import '../home/Home.dart';
import 'registration_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal, // Change the background color to teal
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0,
              color: Colors.white, // Change the card color to white
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Connectez-vous',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal, // Change the text color to teal
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                       String email = emailController.text;
                       String password = passwordController.text;

                        // // Call the method from your UserService
                         var response = await authenticateUser(email, password);
                        SharedPreferences.getInstance().then((prefs) {
                         prefs.setString('accessToken', response.accessToken ?? '');
                         print("here");

                         authenticateUser(email,password);
                        });

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );

                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal, // Change the button color to teal
                        padding: EdgeInsets.symmetric(horizontal: 40.0),

                      ),
                      child: Text(
                        'Se connecter',
                        style: TextStyle(
                          color: Colors.white, // Change the text color to white or any color you prefer
                        ),
                      ),

                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistrationPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.teal, // Change the text color to teal
                      ),
                      child: Text('Pas encore inscrit? Inscrivez-vous'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
