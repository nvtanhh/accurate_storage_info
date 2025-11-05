import 'package:flutter/services.dart';

class StorageInfo {
  static const MethodChannel _ch = MethodChannel('dev.tanh/storage_info');

  static Future<int> getTotalBytes() async => (await _ch.invokeMethod<int>('getTotalBytes'))!;

  static Future<int> getAvailableBytes() async => (await _ch.invokeMethod<int>('getAvailableBytes'))!;

  static Future<int> getUsedBytes() async => (await _ch.invokeMethod<int>('getUsedBytes'))!;
}
