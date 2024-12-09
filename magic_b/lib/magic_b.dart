
import 'magic_b_platform_interface.dart';

class Magic_b {
  Future<String?> getPlatformVersion() {
    return Magic_bPlatform.instance.getPlatformVersion();
  }
}
