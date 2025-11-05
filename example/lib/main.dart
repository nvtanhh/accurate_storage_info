import 'package:accurate_storage_info/storage_info.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String _fmtGiB(int bytes) {
    final gib = bytes / (1024 * 1024 * 1024);
    return gib.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('accurate_storage_info example')),
        body: FutureBuilder<List<int>>(
          future: Future.wait<int>([
            StorageInfo.getTotalBytes(),
            StorageInfo.getAvailableBytes(),
            StorageInfo.getUsedBytes(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final total = snapshot.data![0];
            final available = snapshot.data![1];
            final used = snapshot.data![2];
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total (bytes): $total'),
                  Text('Available (bytes): $available'),
                  Text('Used (bytes): $used'),
                  const SizedBox(height: 12),
                  Text('Total (GiB): ${_fmtGiB(total)}'),
                  Text('Available (GiB): ${_fmtGiB(available)}'),
                  Text('Used (GiB): ${_fmtGiB(used)}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
