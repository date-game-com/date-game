import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> create(String collection, Map<String, dynamic> json) async {
  await _firestore.collection(collection).add(json);
}
