import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

enum Collections {
  person('Person'),
  alias('Alias'),
  ;

  final String name;

  const Collections(this.name);
}

Future<void> setDoc({
  required Collections collection,
  required String id,
  required Map<String, dynamic> json,
}) async {
  await _firestore.collection(collection.name).doc(id).set(json);
}

Future<Map<String, dynamic>?> queryDoc({
  required Collections collection,
  required String id,
}) async {
  return (await _firestore.collection(collection.name).doc(id).get()).data() ??
      {};
}
