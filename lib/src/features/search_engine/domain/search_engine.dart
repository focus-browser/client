import 'package:flutter/foundation.dart';

typedef SearchEngineId = String;

@immutable
class SearchEngine {
  final SearchEngineId id;
  final String name;
  final String urlTemplate;

  const SearchEngine({
    required this.id,
    required this.name,
    required this.urlTemplate,
  });

  @override
  bool operator ==(covariant SearchEngine other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.urlTemplate == urlTemplate;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ urlTemplate.hashCode;

  SearchEngine copyWith({
    String? id,
    String? name,
    String? urlTemplate,
  }) {
    return SearchEngine(
      id: id ?? this.id,
      name: name ?? this.name,
      urlTemplate: urlTemplate ?? this.urlTemplate,
    );
  }

  @override
  String toString() =>
      'SearchEngine(id: $id, name: $name, urlTemplate: $urlTemplate)';
}
