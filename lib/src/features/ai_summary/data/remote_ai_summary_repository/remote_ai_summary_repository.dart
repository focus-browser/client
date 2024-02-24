import 'dart:convert';
import 'dart:io';

import 'package:focus_browser/src/features/ai_summary/data/ai_summary_repository.dart';
import 'package:focus_browser/src/features/ai_summary/data/remote_ai_summary_repository/remote_ai_summary_repository_request.dart';
import 'package:focus_browser/src/features/ai_summary/data/remote_ai_summary_repository/remote_ai_summary_repository_response.dart';
import 'package:http/http.dart' as http;

class RemoteAiSummaryRepository implements AiSummaryRepository {
  RemoteAiSummaryRepository({
    required this.repoUrl,
  });

  final Uri repoUrl;

  @override
  Future<String> summarise(String url) async {
    final request = RemoteAiSummaryRepositoryRequest(url: url);
    final httpResponse = await http.post(
      repoUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: request.toJson(),
    );

    if (httpResponse.statusCode == 200) {
      final response = RemoteAiSummaryRepositoryResponse.fromJson(
          utf8.decode(httpResponse.bodyBytes));
      return response.toString();
    } else {
      throw Exception(
          'Failed to load summary results: statusCode=${httpResponse.statusCode},body=${httpResponse.body}');
    }
  }
}
