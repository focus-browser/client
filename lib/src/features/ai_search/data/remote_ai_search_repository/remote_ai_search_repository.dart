import 'dart:io';

import 'package:bouser/src/features/ai_search/data/ai_search_repository.dart';
import 'package:bouser/src/features/ai_search/data/remote_ai_search_repository/remote_ai_search_repository_request.dart';
import 'package:bouser/src/features/ai_search/data/remote_ai_search_repository/remote_ai_search_repository_response.dart';
import 'package:http/http.dart' as http;

class RemoteAiSearchRepository implements AiSearchRepository {
  RemoteAiSearchRepository({
    required this.url,
  });

  final Uri url;

  @override
  Future<String> search(String query) async {
    final request = RemoteAiSearchRepositoryRequest(query: query);
    final httpResponse = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: request.toJson(),
    );

    if (httpResponse.statusCode == 200) {
      final response =
          RemoteAiSearchRepositoryResponse.fromJson(httpResponse.body);
      return response.toString();
    } else {
      throw Exception(
          'Failed to load search results: statusCode=${httpResponse.statusCode},body=${httpResponse.body}');
    }
  }
}
