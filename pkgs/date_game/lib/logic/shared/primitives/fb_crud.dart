import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

enum Collections {
  person('Person'),
  ;

  final String name;

  const Collections(this.name);
}

Future<void> createDoc({
  required Collections collection,
  required String path,
  required Map<String, dynamic> json,
}) async {
  await _firestore.collection(collection.name).doc(path).set(json);
}

Future<Map<String, dynamic>> queryDoc({
  required Collections collection,
  required String path,
}) async {
  return (await _firestore.collection(collection.name).doc(path).get())
          .data() ??
      {};
}
