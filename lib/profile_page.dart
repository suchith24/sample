import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${user?.displayName ?? 'N/A'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Email: ${user?.email ?? 'N/A'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("UID: ${user?.uid}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
