import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'magic_b_method_channel.dart';

abstract class Magic_bPlatform extends PlatformInterface {
  /// Constructs a Magic_bPlatform.
  Magic_bPlatform() : super(token: _token);

  static final Object _token = Object();

  static Magic_bPlatform _instance = MethodChannelMagic_b();

  /// The default instance of [Magic_bPlatform] to use.
  ///
  /// Defaults to [MethodChannelMagic_b].
  static Magic_bPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Magic_bPlatform] when
  /// they register themselves.
  static set instance(Magic_bPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
