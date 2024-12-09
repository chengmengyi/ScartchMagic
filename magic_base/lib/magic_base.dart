
import 'magic_base_platform_interface.dart';

class MagicBase {
  Future<String?> getPlatformVersion() {
    return MagicBasePlatform.instance.getPlatformVersion();
  }
}
