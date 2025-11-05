import Flutter
import UIKit

public class StorageInfoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dev.tanh/storage_info", binaryMessenger: registrar.messenger())
    let instance = StorageInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    do {
      switch call.method {
      case "getTotalBytes":
        let (total, _, _) = try Self.queryStorage()
        result(total)
      case "getAvailableBytes":
        let (_, available, _) = try Self.queryStorage()
        result(available)
      case "getUsedBytes":
        let (_, _, used) = try Self.queryStorage()
        result(used)
      default:
        result(FlutterMethodNotImplemented)
      }
    } catch StorageError.noDocsDir {
      result(FlutterError(code: "NO_DOCS_DIR", message: "Could not resolve documents directory", details: nil))
    } catch StorageError.noStorageData {
      result(FlutterError(code: "NO_STORAGE_DATA", message: "Storage values unavailable", details: nil))
    } catch {
      result(FlutterError(code: "STORAGE_QUERY_FAILED", message: error.localizedDescription, details: nil))
    }
  }

  private enum StorageError: Error { case noDocsDir, noStorageData }

  private static func queryStorage() throws -> (Int64, Int64, Int64) {
    guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      throw StorageError.noDocsDir
    }

    let keys: Set<URLResourceKey> = [
      .volumeTotalCapacityKey,
      .volumeAvailableCapacityForImportantUsageKey,
      .volumeAvailableCapacityKey
    ]
    let values = try docs.resourceValues(forKeys: keys)

    let total = Int64(values.volumeTotalCapacity ?? 0)
    let availableImportantNum = (values.allValues[.volumeAvailableCapacityForImportantUsageKey] as? NSNumber)?.int64Value ?? 0
    let availableFallbackNum = (values.allValues[.volumeAvailableCapacityKey] as? NSNumber)?.int64Value ?? 0
    let available = (availableImportantNum > 0 ? availableImportantNum : availableFallbackNum)
    let used = total &- available

    if total == 0 && available == 0 {
      throw StorageError.noStorageData
    }

    return (total, available, used)
  }
}
