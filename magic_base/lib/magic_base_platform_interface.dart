import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'magic_base_method_channel.dart';

abstract class MagicBasePlatform extends PlatformInterface {
  /// Constructs a MagicBasePlatform.
  MagicBasePlatform() : super(token: _token);

  static final Object _token = Object();

  static MagicBasePlatform _instance = MethodChannelMagicBase();

  /// The default instance of [MagicBasePlatform] to use.
  ///
  /// Defaults to [MethodChannelMagicBase].
  static MagicBasePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MagicBasePlatform] when
  /// they register themselves.
  static set instance(MagicBasePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
