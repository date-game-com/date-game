import 'package:cloud_firestore/cloud_firestore.dart';

import 'docs.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Collections {
  static final person = DataCollection((json) => Person.fromJson(json));
  static final alias = DataCollection((json) => Alias.fromJson(json));
}

class DataCollection<T extends DateGameDoc> {
  final T Function(Map<String, dynamic>) parser;

  const DataCollection(this.parser);

  String get name => T.toString();

  Future<void> set({
    required String id,
    required T doc,
  }) async {
    await _firestore.collection(name).doc(id).set(doc.toJson());
  }

  Future<T?> query(String id) async {
    final json = (await _firestore.collection(name).doc(id).get()).data();
    if (json == null) return null;
    return parser(json);
  }
}
