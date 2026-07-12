import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContinueWatchingFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveProgress({
    required String title,
    required String posterPath,
    required String videoPath,
    required int position,
    required int duration,
  }) async {
    final user = _auth.currentUser;

    print("Current User = ${user?.uid}");

    if (user == null) return;

    try {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("continueWatching")
          .doc(title)
          .set({
            "title": title,
            "posterPath": posterPath,
            "videoPath": videoPath,
            "position": position,
            "duration": duration,
            "lastWatched": FieldValue.serverTimestamp(),
          });

      print("Firestore Save Success");
    } catch (e) {
      print("Firestore Error = $e");
    }
  }

  Stream<QuerySnapshot> getContinueWatching() {
    final user = _auth.currentUser;

    return _firestore
        .collection("users")
        .doc(user!.uid)
        .collection("continueWatching")
        .snapshots();
  }
}
