import 'package:magic_b/utils/guide/guide_step.dart';
import 'package:magic_base/utils/storage/storage_hep.dart';
import 'package:magic_b/utils/b_storage/b_storage_name.dart';

StorageHep<int> coins=StorageHep<int>(key: BStorageName.coins, defaultValue: 0);
StorageHep<int> playedCardNum=StorageHep<int>(key: BStorageName.playedCardNum, defaultValue: 0);
StorageHep<int> wheelChanceNum=StorageHep<int>(key: BStorageName.wheelChanceNum, defaultValue: 0);
StorageHep<int> currentBoxProgress=StorageHep<int>(key: BStorageName.currentBoxProgress, defaultValue: 0);
//0pay 1 ama 2gp 3mas 4cash 5web
StorageHep<int> cashTypeIndex=StorageHep<int>(key: BStorageName.cashTypeIndex, defaultValue: 0);
StorageHep<int> countMoney=StorageHep<int>(key: BStorageName.countMoney, defaultValue: 0);

StorageHep<String> currentGuideStep=StorageHep<String>(key: BStorageName.currentGuideStep, defaultValue: GuideStep.showFirstPlayGuide);
StorageHep<String> newUserGuideCompletedTimer=StorageHep<String>(key: BStorageName.newUserGuideCompletedTimer, defaultValue: "");
StorageHep<String> oldUserGuideStep=StorageHep<String>(key: BStorageName.oldUserGuideStep, defaultValue: OldGuideStep.showOldUserDialog);
StorageHep<String> valueConf=StorageHep<String>(key: BStorageName.valueConf, defaultValue: "");


StorageHep<bool> firstShowBoxGuide=StorageHep<bool>(key: BStorageName.firstShowBoxGuide, defaultValue: true);
StorageHep<bool> firstGetMoney=StorageHep<bool>(key: BStorageName.firstGetMoney, defaultValue: true);
StorageHep<bool> firstLaunchApp=StorageHep<bool>(key: BStorageName.firstLaunchApp, defaultValue: true);

