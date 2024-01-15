Stream<String> streamString(String input) async* {
  String output = '';
  List<String> words = input.split(' ');
  for (String word in words) {
    output += '$word ';
    yield output;
    await Future.delayed(const Duration(milliseconds: 10));
  }
}
