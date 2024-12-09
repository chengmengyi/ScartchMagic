
import 'magic_normal_platform_interface.dart';

class MagicNormal {
  Future<String?> getPlatformVersion() {
    return MagicNormalPlatform.instance.getPlatformVersion();
  }
}
