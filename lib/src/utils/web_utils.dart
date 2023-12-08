bool isWebAddress(String input) {
  const urlPattern =
      r'^((http|https):\/\/)*[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?$';
  final urlRegex = RegExp(urlPattern);
  return urlRegex.hasMatch(input);
}
