import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firestore service for registered users only.
///
/// Screens now use the local SQLite database via AppDatabase.
/// This service is only used internally by SyncService for Firebase sync.
class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── User Profile ───────────────────────────────────────────────────────────

  static Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'userId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  static Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> fields,
  }) async {
    await _db.collection('users').doc(uid).update(fields);
  }

  // ─── History ────────────────────────────────────────────────────────────────
  // These methods are deprecated for direct screen usage.
  // Instead, screens should use AppDatabase and SyncService handles Firestore sync.

  static Future<void> saveCalculation({
    required int height,
    required int weight,
    required int age,
    required bool isMale,
    required String bmiResult,
    required String resultText,
    required String interpretation,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection('history').add({
      'userId': user.uid,
      'height': height,
      'weight': weight,
      'age': age,
      'isMale': isMale,
      'bmiResult': bmiResult,
      'resultText': resultText,
      'interpretation': interpretation,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<List<Map<String, dynamic>>> fetchHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await _db
        .collection('history')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Future<void> deleteHistoryRecord(String docId) async {
    await _db.collection('history').doc(docId).delete();
  }

  // ─── 2FA Configuration ──────────────────────────────────────────────────────

  static Future<void> save2faConfig(String uid, Map<String, dynamic> config) async {
    await _db.collection('users').doc(uid).collection('settings').doc('twofa').set({
      ...config,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<Map<String, dynamic>?> get2faConfig(String uid) async {
    final doc =
        await _db.collection('users').doc(uid).collection('settings').doc('twofa').get();
    return doc.exists ? doc.data() : null;
  }

  static Future<void> delete2faConfig(String uid) async {
    await _db.collection('users').doc(uid).collection('settings').doc('twofa').delete();
  }
}
