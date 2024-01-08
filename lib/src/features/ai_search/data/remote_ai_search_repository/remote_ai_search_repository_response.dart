// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RemoteAiSearchRepositoryResponse {
  const RemoteAiSearchRepositoryResponse({
    required this.response,
    required this.references,
  });

  final String response;
  final List<RemoteAiSearchRepositoryResponseReference> references;

  @override
  String toString() {
    String formattedString = '$response\n\n';
    formattedString += 'Sources:\n';
    for (var i = 0; i < references.length; i++) {
      formattedString += '[${i + 1}]: ${references[i].url}\n';
    }
    return formattedString;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'response': response,
      'references': references.map((x) => x.toMap()).toList(),
    };
  }

  factory RemoteAiSearchRepositoryResponse.fromMap(Map<String, dynamic> map) {
    return RemoteAiSearchRepositoryResponse(
      response: map['response'] as String,
      references: List<RemoteAiSearchRepositoryResponseReference>.from(
        (map['references'] as List<dynamic>)
            .map<RemoteAiSearchRepositoryResponseReference>(
          (x) => RemoteAiSearchRepositoryResponseReference.fromMap(
              x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteAiSearchRepositoryResponse.fromJson(String source) =>
      RemoteAiSearchRepositoryResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class RemoteAiSearchRepositoryResponseReference {
  const RemoteAiSearchRepositoryResponseReference({
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
    };
  }

  factory RemoteAiSearchRepositoryResponseReference.fromMap(
      Map<String, dynamic> map) {
    return RemoteAiSearchRepositoryResponseReference(
      title: map['title'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteAiSearchRepositoryResponseReference.fromJson(String source) =>
      RemoteAiSearchRepositoryResponseReference.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
