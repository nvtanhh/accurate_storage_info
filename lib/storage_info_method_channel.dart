import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'storage_info_platform_interface.dart';

/// An implementation of [StorageInfoPlatform] that uses method channels.
class MethodChannelStorageInfo extends StorageInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('storage_info');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
