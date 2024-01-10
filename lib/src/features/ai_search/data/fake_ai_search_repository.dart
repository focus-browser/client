import 'package:bouser/src/constants/lorem_ipsum.dart';
import 'package:bouser/src/features/ai_search/data/ai_search_repository.dart';
import 'package:bouser/src/features/ai_search/data/remote_ai_search_repository/remote_ai_search_repository_response.dart';
import 'package:bouser/src/utils/delay.dart';

typedef FakeAiSearchRepositoryResponse = RemoteAiSearchRepositoryResponse;
typedef FakeAiSearchRepositoryResponseReference
    = RemoteAiSearchRepositoryResponseReference;

class FakeAiSearchRepository implements AiSearchRepository {
  FakeAiSearchRepository({
    this.addDelay = true,
  });

  final bool addDelay;
  final FakeAiSearchRepositoryResponse _response =
      const FakeAiSearchRepositoryResponse(
    response: loremIpsum,
    references: [
      FakeAiSearchRepositoryResponseReference(
        title: 'Lorem Ipsum',
        url: 'https://en.wikipedia.org/wiki/Lorem_ipsum',
      ),
      FakeAiSearchRepositoryResponseReference(
        title: 'What does the filler text “lorem ipsum” mean?',
        url:
            'https://www.straightdope.com/21343427/what-does-the-filler-text-lorem-ipsum-mean',
      ),
    ],
  );

  @override
  Future<String> search(String query) async {
    await delay(addDelay);
    return _response.toString();
  }
}
