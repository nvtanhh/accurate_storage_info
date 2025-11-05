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
          return 1000;
        case 'getAvailableBytes':
          return 400;
        case 'getUsedBytes':
          return 600;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getTotalBytes returns mocked value', () async {
    expect(await StorageInfo.getTotalBytes(), 1000);
  });

  test('getAvailableBytes returns mocked value', () async {
    expect(await StorageInfo.getAvailableBytes(), 400);
  });

  test('getUsedBytes returns mocked value', () async {
    expect(await StorageInfo.getUsedBytes(), 600);
  });
}
