import 'dart:convert';

import 'package:flutter/foundation.dart';

typedef SearchEngineId = String;
typedef SearchEngineRecord = ({SearchEngineId id, SearchEngine engine});

@immutable
class SearchEngine {
  final String name;
  final String urlTemplate;

  const SearchEngine({
    required this.name,
    required this.urlTemplate,
  });

  @override
  bool operator ==(covariant SearchEngine other) {
    if (identical(this, other)) return true;

    return other.name == name && other.urlTemplate == urlTemplate;
  }

  @override
  int get hashCode => name.hashCode ^ urlTemplate.hashCode;

  @override
  String toString() => 'SearchEngine(name: $name, urlTemplate: $urlTemplate)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'urlTemplate': urlTemplate,
    };
  }

  factory SearchEngine.fromMap(Map<String, dynamic> map) {
    return SearchEngine(
      name: map['name'] as String,
      urlTemplate: map['urlTemplate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchEngine.fromJson(String source) =>
      SearchEngine.fromMap(json.decode(source) as Map<String, dynamic>);
}
