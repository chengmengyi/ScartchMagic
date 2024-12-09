import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'magic_b_platform_interface.dart';

/// An implementation of [Magic_bPlatform] that uses method channels.
class MethodChannelMagic_b extends Magic_bPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('magic_b');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
