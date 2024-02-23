bool isWebAddress(String input) {
  const urlPattern =
      r'^((http|https):\/\/)*[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?$';
  final urlRegex = RegExp(urlPattern);
  return urlRegex.hasMatch(input);
}

String getProtocolAndBaseDomain(String url) {
  final uri = Uri.parse(url);
  return '${uri.scheme}://${uri.host}';
}

String getFaviconUrlFromUrl(String url) {
  final protocolAndBaseDomain = getProtocolAndBaseDomain(url);
  return '$protocolAndBaseDomain/favicon.ico';
}
