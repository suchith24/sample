import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'This app demonstrates Firebase Authentication using Email, Phone, and Google sign-in in Flutter. It also includes user profile, info page, and user listing features.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
