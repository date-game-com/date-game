import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

import 'docs.dart';

var _log = Logger('collections.dart');

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Collections {
  static final person =
      DataCollection('Person', (json) => Person.fromJson(json));
  static final alias = DataCollection('Alias', (json) => Alias.fromJson(json));
}

class DataCollection<T extends DateGameDoc> {
  const DataCollection(this.name, this.parser);

  final T Function(Map<String, dynamic>) parser;
  final String name;

  Future<void> set({
    required String id,
    required T doc,
  }) async {
    try {
      await _firestore.collection(name).doc(id).set(doc.toJson());
      _log.fine('Set $name, $id');
    } catch (e) {
      _log.severe('Error setting $name, $id: $e');
      rethrow;
    }
  }

  Future<T?> query(String id) async {
    try {
      final json = (await _firestore.collection(name).doc(id).get()).data();
      _log.fine('Queried $name, $id: $json');
      if (json == null) return null;
      return parser(json);
    } catch (e) {
      _log.severe('Error getting $name, $id: $e');
      rethrow;
    }
  }
}
