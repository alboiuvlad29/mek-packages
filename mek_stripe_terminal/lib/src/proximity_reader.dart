import 'package:flutter/foundation.dart';
import 'package:mek_stripe_terminal/src/api/proximity_reader_api.g.dart';
import 'package:meta/meta.dart';

@experimental
class ProximityReader extends ProximityReaderPlatformApi {
  ProximityReader({super.binaryMessenger, super.messageChannelSuffix});

  /// Presents Apple's "How to Tap" education screen. iOS 18+ only, no-op on other platforms.
  @override
  Future<void> presentHowToTap() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    await super.presentHowToTap();
  }
}
