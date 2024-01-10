import 'package:focus_browser/src/features/share/data/share_repository.dart';
import 'package:share_plus/share_plus.dart';

class SharePlusRepository implements ShareRepository {
  @override
  Future<void> share(String url) async {
    Share.shareUri(Uri.parse(url));
  }
}
