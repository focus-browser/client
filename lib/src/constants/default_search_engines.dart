import 'package:focus_browser/src/features/search_engine/domain/search_engine.dart';

const kDefaultSearchEngines = {
  '6ba55eac-f0fe-412a-bcf8-9aa3b44bd110': SearchEngine(
    name: 'Google',
    urlTemplate: 'https://google.com/search?q=%s',
  ),
  'c0fe8be4-79f4-4691-ac9c-14a87fe6af9a': SearchEngine(
    name: 'Bing',
    urlTemplate: 'https://bing.com/search?q=%s',
  ),
  'd6e6d6fd-0210-46ec-a52a-cc3f7e2bf95d': SearchEngine(
    name: 'DuckDuckGo',
    urlTemplate: 'https://duckduckgo.com/?q=%s',
  ),
};
