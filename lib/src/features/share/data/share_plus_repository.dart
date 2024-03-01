import 'package:flutter/services.dart';
import 'package:focus_browser/src/features/share/data/share_repository.dart';

/// Until share_plus package has updated its shareUri method to accept a
/// sharePositionOrigin parameter, we will use the platform channel directly.
/// https://github.com/fluttercommunity/plus_plugins/issues/2464#issue-2045226755

const MethodChannel _channel = MethodChannel('dev.fluttercommunity.plus/share');

class SharePlusRepository implements ShareRepository {
  @override
  Future<void> share(String url, [Rect? sharePositionOrigin]) async {
    final params = <String, dynamic>{'uri': url};
    if (sharePositionOrigin != null) {
      params['originX'] = sharePositionOrigin.left;
      params['originY'] = sharePositionOrigin.top;
      params['originWidth'] = sharePositionOrigin.width;
      params['originHeight'] = sharePositionOrigin.height;
    }
    return _channel.invokeMethod<void>('shareUri', params);
  }
}
