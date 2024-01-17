

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User/Login.dart';
import 'Home.dart';


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String? Token ;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
getToken()async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Token = prefs.getString('accessToken');
}
  @override
  void initState() {
  getToken();
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Create fade and scale animations
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);

    // Start the animations
    _controller.forward();

    // Navigate to the login page after a delay
    Future.delayed(Duration(seconds: 4), () {
      print(Token);
  Token==null ?     Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      ):  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset('assets/logo.png', width: 300, height: 400),
          ),
        ),
      ),
    );
  }
}
