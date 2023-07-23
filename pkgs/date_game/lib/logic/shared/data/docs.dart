abstract class DateGameDoc {
  Map<String, dynamic> toJson();
}

enum _Json {
  alias,
}

/// Id is user id.
class Person extends DateGameDoc {
  Person({
    required this.alias,
  });

  Person.fromJson(Map<String, dynamic> json) : alias = json[_Json.alias.name];
  final String alias;

  @override
  Map<String, dynamic> toJson() => {_Json.alias.name: alias};
}

/// Index of taken aliases, one doc per alias.
///
/// Id is the alias.
class Alias extends DateGameDoc {
  Alias({
    required this.alias,
  });

  Alias.fromJson(Map<String, dynamic> json) : alias = json[_Json.alias.name];
  final String alias;

  @override
  Map<String, dynamic> toJson() => {_Json.alias.name: alias};
}
