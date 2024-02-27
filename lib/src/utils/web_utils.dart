/// Checks if the input is a valid web address.
/// Partial addresses are also considered valid, e.g. "google.com"
bool isWebAddress(String input) {
  const urlPattern =
      r'^((http|https):\/\/)*[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?$';
  final urlRegex = RegExp(urlPattern);
  return urlRegex.hasMatch(input);
}

/// Checks if the input is a valid url.
bool isValidUrl(String url) {
  Uri uri;
  try {
    uri = Uri.parse(url);
  } catch (e) {
    return false;
  }
  return uri.hasScheme && uri.hasAuthority;
}

String getProtocolAndBaseDomain(String url) {
  final uri = Uri.parse(url);
  return '${uri.scheme}://${uri.host}';
}

String getFaviconUrlFromUrl(String url) {
  final protocolAndBaseDomain = getProtocolAndBaseDomain(url);
  return '$protocolAndBaseDomain/favicon.ico';
}
