import 'package:flutter/widgets.dart';
import 'package:focus_browser/src/utils/web_utils.dart';

/// A widget that shows an image from a network URL.
/// If the URL is invalid, it shows the [errorWidget] instead.
class ImageNetwork extends StatelessWidget {
  const ImageNetwork({
    super.key,
    required this.url,
    required this.errorWidget,
  });

  final String url;
  final Widget errorWidget;

  @override
  Widget build(BuildContext context) {
    if (isValidUrl(url)) {
      return Image.network(
        url,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    }
    return errorWidget;
  }
}
