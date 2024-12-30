import 'package:bmi_calculator/components/reusable_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/profile_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>?> _fetchUserDetails() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _fetchUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text('No user data found.'),
              );
            }

            final userData = snapshot.data!;

            return ReusableCard(
              colour: Colors.teal,
              cardChild: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Page Title
                    const Text(
                      "View Profile",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Circular Avatar
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.teal,
                      ),
                    ),
                    Text(
                      userData['name'] ?? 'N/A',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 40.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'BMI APP USER',
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        color: Colors.teal.shade100,
                        fontSize: 20.0,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                      width: 150.0,
                      child: Divider(
                        color: Colors.teal.shade100,
                      ),
                    ),

                    const SizedBox(height: 16),
                    ProfileCard(
                      icon: Icons.email,
                      title: "Email",
                      value: userData['email'] ?? 'N/A',
                    ),
                    const SizedBox(height: 16),
                    ProfileCard(
                      icon: Icons.phone,
                      title: "Phone",
                      value: userData['phone'] ?? 'N/A',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
