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
  required Map<String, dynamic> json,
}) async {
  await _firestore.collection(collection.name).add(json);
}
