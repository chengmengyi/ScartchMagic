import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'magic_normal_method_channel.dart';

abstract class MagicNormalPlatform extends PlatformInterface {
  /// Constructs a MagicNormalPlatform.
  MagicNormalPlatform() : super(token: _token);

  static final Object _token = Object();

  static MagicNormalPlatform _instance = MethodChannelMagicNormal();

  /// The default instance of [MagicNormalPlatform] to use.
  ///
  /// Defaults to [MethodChannelMagicNormal].
  static MagicNormalPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MagicNormalPlatform] when
  /// they register themselves.
  static set instance(MagicNormalPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
