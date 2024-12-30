import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
        tileColor: Colors.white,
        leading: Icon(icon, color: Colors.teal),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.teal.shade900,
            fontFamily: 'Source Sans Pro',
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: Colors.teal.shade900,
            fontFamily: 'Source Sans Pro',
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
