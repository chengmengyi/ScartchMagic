import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'magic_base_platform_interface.dart';

/// An implementation of [MagicBasePlatform] that uses method channels.
class MethodChannelMagicBase extends MagicBasePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('magic_base');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
