import 'package:focus_browser/src/constants/lorem_ipsum.dart';
import 'package:focus_browser/src/features/ai_search/data/ai_search_repository.dart';
import 'package:focus_browser/src/features/ai_search/data/remote_ai_search_repository/remote_ai_search_repository_response.dart';
import 'package:focus_browser/src/utils/delay.dart';

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
    response: loremIpsumMarkdown,
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
      FakeAiSearchRepositoryResponseReference(
        title: 'Lorem Ipsum 2',
        url: 'https://en.wikipedia.org/wiki/Lorem_ipsum2',
      ),
      FakeAiSearchRepositoryResponseReference(
        title: 'What does the filler text “lorem ipsum” mean? 2',
        url:
            'https://www.straightdope.com/21343427/what-does-the-filler-text-lorem-ipsum-mean2',
      ),
      FakeAiSearchRepositoryResponseReference(
        title: 'Lorem Ipsum 3',
        url: 'https://en.wikipedia.org/wiki/Lorem_ipsum3',
      ),
      FakeAiSearchRepositoryResponseReference(
        title: 'What does the filler text “lorem ipsum” mean? 3',
        url:
            'https://www.straightdope.com/21343427/what-does-the-filler-text-lorem-ipsum-mean3',
      ),
    ],
  );

  @override
  Future<String> search(String query) async {
    await delay(addDelay);
    return _response.toString();
  }
}
