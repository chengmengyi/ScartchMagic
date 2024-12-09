import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_base/utils/storage/storage_hep.dart';
import 'package:magic_b/utils/b_storage/b_storage_name.dart';

StorageHep<int> coins=StorageHep<int>(key: BStorageName.coins, defaultValue: 0);
StorageHep<String> currentGuideStep=StorageHep<String>(key: BStorageName.currentGuideStep, defaultValue: GuideStep.showFirstPlayGuide);