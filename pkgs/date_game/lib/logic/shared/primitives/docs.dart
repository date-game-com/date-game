/// Id is user id.
class Person {
  final String alias;

  const Person({
    required this.alias,
  });

  Person.fromJson(Map<String, dynamic> json) : alias = json[_Json.alias.name];

  Map<String, dynamic> toJson() => {'_Json.alias.name': alias};
}

/// Index of taken aliases, one doc per alias.
///
/// Id is the alias.
class Alias {
  final String alias;

  const Alias({
    required this.alias,
  });

  Alias.fromJson(Map<String, dynamic> json) : alias = json[_Json.alias.name];

  Map<String, dynamic> toJson() => {'_Json.alias.name': alias};
}

enum _Json {
  alias,
}
