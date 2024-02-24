import 'package:focus_browser/src/constants/lorem_ipsum.dart';
import 'package:focus_browser/src/features/ai_summary/data/ai_summary_repository.dart';
import 'package:focus_browser/src/features/ai_summary/data/remote_ai_summary_repository/remote_ai_summary_repository_response.dart';
import 'package:focus_browser/src/utils/delay.dart';

typedef FakeAiSummaryRepositoryResponse = RemoteAiSummaryRepositoryResponse;

class FakeAiSummaryRepository implements AiSummaryRepository {
  FakeAiSummaryRepository({
    this.addDelay = true,
  });

  final bool addDelay;
  final FakeAiSummaryRepositoryResponse _response =
      const FakeAiSummaryRepositoryResponse(
    response: loremIpsumMarkdownSummary,
  );

  @override
  Future<String> summarise(String url) async {
    await delay(addDelay);
    return _response.toString();
  }
}
