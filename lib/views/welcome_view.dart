
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mediapp/views/login_view/login_view.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Column(
                    children: [
                      // Icon(
                      //   // Icons.stethoscope,
                      //   // size: 80,
                      //   color: Colors.lightBlueAccent,
                      // ),
                      SizedBox(height: 20),
                      Icon(
                        Icons.email,
                        size: 40,
                        color: Colors.lightBlueAccent,
                      ),
                      SizedBox(height: 20),
                      Icon(
                        Icons.favorite,
                        size: 30,
                        color: Colors.lightBlueAccent,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text(
                'Hello!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to MediAPP Your trusted partner in health. Schedule appointments with leading doctors and specialists with just a few taps. We are here to ensure your well-being.    Tap "Start" to proceed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Add your onPressed code here!
                  Get.to(() => LoginView());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
