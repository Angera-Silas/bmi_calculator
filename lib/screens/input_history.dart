import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class InputHistory extends StatefulWidget {
  const InputHistory({super.key});

  @override
  State<InputHistory> createState() => _InputHistoryState();
}

class _InputHistoryState extends State<InputHistory> {
  late Future<List<Map<String, dynamic>>> historyList;

  // Function to format timestamp to a readable date string
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    if (now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day) {
      return "Today";
    } else if (now.subtract(Duration(days: 1)).day == dateTime.day) {
      return "Yesterday";
    } else {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }
  }

  // Function to fetch history from Firestore
  Future<List<Map<String, dynamic>>> fetchHistory() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return []; // No user is logged in
    }

    // Query Firestore for history data
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('history')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp',
            descending: true) // Order by timestamp (most recent first)
        .get();

    List<Map<String, dynamic>> history = [];
    for (var doc in querySnapshot.docs) {
      history.add(doc.data() as Map<String, dynamic>);
    }

    return history;
  }

  @override
  void initState() {
    super.initState();
    historyList = fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: historyList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error fetching history"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 100,
                  color: DynamicColors.activeCardColor(context),
                ),
                Text(
                  "No records found",
                  style: TextStyle(
                    fontSize: 20,
                    color: DynamicColors.activeCardColor(context),
                  ),
                ),
              ],
            ),
          );
        }

        List<Map<String, dynamic>> history = snapshot.data!;

        // Grouping history by date (Today, Yesterday, or specific dates)
        Map<String, List<Map<String, dynamic>>> groupedHistory = {};

        for (var record in history) {
          String formattedDate = formatTimestamp(record['timestamp']);
          if (!groupedHistory.containsKey(formattedDate)) {
            groupedHistory[formattedDate] = [];
          }
          groupedHistory[formattedDate]!.add(record);
        }

        return ListView.builder(
          itemCount: groupedHistory.keys.length,
          itemBuilder: (context, index) {
            String date = groupedHistory.keys.elementAt(index);
            List<Map<String, dynamic>> records = groupedHistory[date]!;

            return ExpansionTile(
              title: Text(date),
              children: records.map((record) {
                String bmi = record['bmiResult'];
                String resultText = record['resultText'];
                String interpretation = record['interpretation'];

                return ListTile(
                  title: Text("BMI: ${bmi}"),
                  subtitle: Text("$resultText - $interpretation"),
                  trailing: Text(
                    "${record['height']} cm, ${record['weight']} kg, ${record['age']} years",
                    style: TextStyle(
                        // color: DynamicColors.activeCardColor(context),
                        ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
