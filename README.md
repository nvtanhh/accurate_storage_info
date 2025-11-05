<div align="center">

# accurate_storage_info

Accurate disk storage information (in bytes) for iOS and Android.

<p align="center">
  <a href="https://pub.dev/packages/accurate_storage_info">
    <img src="https://img.shields.io/pub/v/accurate_storage_info.svg" alt="pub.dev version">
  </a>
  <a href="https://github.com/nvtanhh/accurate_storage_info">
    <img src="https://img.shields.io/github/stars/nvtanhh/accurate_storage_info?style=social" alt="GitHub stars">
  </a>
  <a href="https://github.com/nvtanhh/accurate_storage_info/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="license: MIT">
  </a>
  <img src="https://img.shields.io/badge/platform-android%20%7C%20ios-blue" alt="platforms">
</p>

</div>

## Features

- Returns **total**, **available**, and **used** storage in bytes (`int` / `Int64`)
- **iOS:** uses `volumeAvailableCapacityForImportantUsage` for values that closely align with the *Settings > General > iPhone Storage* display
- **Android:** uses `StatFs.availableBytes` (not `freeBytes`) to represent user-available storage

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  accurate_storage_info: ^0.1.0
```

Then run:

```sh
flutter pub get
```

## Usage

```dart
import 'package:accurate_storage_info/storage_info.dart';

Future<void> loadStorage() async {
  final total = await StorageInfo.getTotalBytes();
  final available = await StorageInfo.getAvailableBytes();
  final used = await StorageInfo.getUsedBytes(); // computed as total - available

  double toGiB(int bytes) => bytes / (1024 * 1024 * 1024);

  print('total=$total, available=$available, used=$used');

  print('totalGiB=${toGiB(total).toStringAsFixed(2)}');
  print('availableGiB=${toGiB(available).toStringAsFixed(2)}');
  print('usedGiB=${toGiB(used).toStringAsFixed(2)}');
}
```

See the example project in `example/lib/main.dart`.

## API

```dart
class StorageInfo {
  static Future<int> getTotalBytes();
  static Future<int> getAvailableBytes();
  static Future<int> getUsedBytes(); // computed = total - available
}
```

All values are returned in **bytes**.

## Platform Details

### iOS

The plugin queries the volume backing the app sandbox:

```swift
FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
```

It uses:

| API Key | Meaning |
|---|---|
| `volumeTotalCapacityKey` | Total storage capacity |
| `volumeAvailableCapacityForImportantUsageKey` | Available storage suitable for user/data workloads |
| (Fallback) `volumeAvailableCapacityKey` | Used only when important-available is not positive |

`used = total - available`

If both `total` and `available` resolve to `0`, the plugin throws a `FlutterError`.

**Rationale:**  
`volumeAvailableCapacityForImportantUsage` accounts for **purgeable** system-managed storage and generally matches the value users see in **Settings**.

### Android

Uses:

```kotlin
val stat = StatFs(Environment.getDataDirectory().path)
total = stat.totalBytes
available = stat.availableBytes
```

`used = total - available`

`availableBytes` reflects **user-available** storage, whereas `freeBytes` may include system-reserved space and typically does **not** match UI expectations.

## Repository

GitHub: [nvtanhh/accurate_storage_info](https://github.com/nvtanhh/accurate_storage_info)

## Troubleshooting

- If Dart imports fail, run `flutter pub get`.
- iOS values are most accurate on **real devices**; the simulator does not represent actual device storage.
- Ensure the app has permission to run normally; no additional storage permissions are required.

## License

MIT. See `LICENSE`.

## Changelog

See `CHANGELOG.md`.
