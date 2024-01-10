import 'dart:convert';

class RemoteAiSearchRepositoryRequest {
  const RemoteAiSearchRepositoryRequest({
    required this.query,
  });

  final String query;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'query': query,
    };
  }

  factory RemoteAiSearchRepositoryRequest.fromMap(Map<String, dynamic> map) {
    return RemoteAiSearchRepositoryRequest(
      query: map['query'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteAiSearchRepositoryRequest.fromJson(String source) =>
      RemoteAiSearchRepositoryRequest.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
