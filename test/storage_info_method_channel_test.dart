import 'package:accurate_storage_info/storage_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('dev.tanh/storage_info');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      MethodCall methodCall,
    ) async {
      switch (methodCall.method) {
        case 'getTotalBytes':
          return 2048;
        case 'getAvailableBytes':
          return 1024;
        case 'getUsedBytes':
          return 1024;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('method channel returns mocked total', () async {
    expect(await StorageInfo.getTotalBytes(), 2048);
  });

  test('method channel returns mocked available', () async {
    expect(await StorageInfo.getAvailableBytes(), 1024);
  });

  test('method channel returns mocked used', () async {
    expect(await StorageInfo.getUsedBytes(), 1024);
  });
}
