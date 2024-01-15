import 'dart:convert';

class RemoteAiSummaryRepositoryRequest {
  const RemoteAiSummaryRepositoryRequest({
    required this.url,
  });

  final String url;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
    };
  }

  factory RemoteAiSummaryRepositoryRequest.fromMap(Map<String, dynamic> map) {
    return RemoteAiSummaryRepositoryRequest(
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteAiSummaryRepositoryRequest.fromJson(String source) =>
      RemoteAiSummaryRepositoryRequest.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
