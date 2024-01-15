import 'dart:convert';

class RemoteAiSummaryRepositoryResponse {
  const RemoteAiSummaryRepositoryResponse({
    required this.response,
  });

  final String response;

  @override
  String toString() => response;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'response': response,
    };
  }

  factory RemoteAiSummaryRepositoryResponse.fromMap(Map<String, dynamic> map) {
    return RemoteAiSummaryRepositoryResponse(
      response: map['response'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteAiSummaryRepositoryResponse.fromJson(String source) =>
      RemoteAiSummaryRepositoryResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
