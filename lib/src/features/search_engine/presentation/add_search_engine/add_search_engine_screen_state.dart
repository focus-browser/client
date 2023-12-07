import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSearchEngineScreenState {
  AddSearchEngineScreenState({
    required this.value,
    required this.name,
    required this.urlTemplate,
  });

  final AsyncValue<void> value;
  final String name;
  final String urlTemplate;

  @override
  bool operator ==(covariant AddSearchEngineScreenState other) {
    if (identical(this, other)) return true;

    return other.value == value &&
        other.name == name &&
        other.urlTemplate == urlTemplate;
  }

  @override
  int get hashCode => value.hashCode ^ name.hashCode ^ urlTemplate.hashCode;

  @override
  String toString() =>
      'AddSearchEngineScreenState(value: $value, name: $name, urlTemplate: $urlTemplate)';

  AddSearchEngineScreenState copyWith({
    AsyncValue<void>? value,
    String? name,
    String? urlTemplate,
  }) {
    return AddSearchEngineScreenState(
      value: value ?? this.value,
      name: name ?? this.name,
      urlTemplate: urlTemplate ?? this.urlTemplate,
    );
  }
}
