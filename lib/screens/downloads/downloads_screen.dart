import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/downloader_provider.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Downloads',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0B1020),
        foregroundColor: Colors.white,
      ),
      body: Consumer<DownloaderProvider>(
        builder: (context, provider, child) {
          final downloads = provider.downloads;

          if (downloads.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_for_offline_outlined,
                      size: 80,
                      color: Colors.white24,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No Downloads Yet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your downloaded files will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: downloads.length,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = downloads[index];

              final bool isCompleted =
                  item.status == 'Completed';

              final bool isDownloading =
                  item.status == 'Downloading';

              final bool isFailed =
                  item.status == 'Failed';

              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding:
                  const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) async {
                  await provider.removeDownload(
                    item.id,
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Download removed.',
                      ),
                      behavior:
                      SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151B2D),
                    borderRadius:
                    BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white10,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              color:
                              const Color(0xFF635BFF)
                                  .withOpacity(0.15),
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                            child: Icon(
                              item.format == 'MP4'
                                  ? Icons
                                  .video_file_rounded
                                  : Icons
                                  .audio_file_rounded,
                              color:
                              const Color(0xFF8B7FFF),
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.platform,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  item.format == 'MP4'
                                      ? '${item.format} • ${item.quality ?? ''}'
                                      : item.format,
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Row(
                                  children: [
                                    Icon(
                                      isCompleted
                                          ? Icons
                                          .check_circle_rounded
                                          : isFailed
                                          ? Icons
                                          .error_rounded
                                          : isDownloading
                                          ? Icons
                                          .downloading_rounded
                                          : Icons
                                          .hourglass_top_rounded,
                                      size: 15,
                                      color: isCompleted
                                          ? Colors.greenAccent
                                          : isFailed
                                          ? Colors.redAccent
                                          : Colors
                                          .orangeAccent,
                                    ),

                                    const SizedBox(width: 5),

                                    Text(
                                      item.status,
                                      style: TextStyle(
                                        color: isCompleted
                                            ? Colors
                                            .greenAccent
                                            : isFailed
                                            ? Colors
                                            .redAccent
                                            : Colors
                                            .orangeAccent,
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          if (isCompleted)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.greenAccent,
                            ),
                        ],
                      ),

                      if (isDownloading) ...[
                        const SizedBox(height: 14),

                        LinearProgressIndicator(
                          value: item.progress,
                          minHeight: 5,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),

                        const SizedBox(height: 6),

                        Align(
                          alignment:
                          Alignment.centerRight,
                          child: Text(
                            '${(item.progress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],

                      if (isCompleted &&
                          item.filePath != null) ...[
                        const SizedBox(height: 10),

                        Align(
                          alignment:
                          Alignment.centerLeft,
                          child: Text(
                            'Saved successfully',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}