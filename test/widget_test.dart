import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:video_downloader/main.dart';
import 'package:video_downloader/providers/downloader_provider.dart';

void main() {
  testWidgets(
    'Video Downloader app loads',
        (WidgetTester tester) async {
      final provider = DownloaderProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: const VideoDownloaderApp(),
        ),
      );

      await tester.pump();

      expect(
        find.text('Video Downloader'),
        findsOneWidget,
      );
    },
  );
}