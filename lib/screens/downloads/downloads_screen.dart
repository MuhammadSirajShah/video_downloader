import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

import '../../providers/downloader_provider.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  Future<void> _openFile(
      BuildContext context,
      String filePath,
      ) async {
    final file = File(filePath);

    if (!await file.exists()) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'File no longer exists.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );

      return;
    }

    final result = await OpenFilex.open(filePath);

    if (!context.mounted) return;

    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              result.message.isNotEmpty
                  ? result.message
                  : 'Could not open the file.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  Future<void> _deleteDownload(
      BuildContext context,
      DownloaderProvider provider,
      DownloadItem item,
      ) async {
    if (item.filePath != null &&
        item.filePath!.isNotEmpty) {
      final file = File(item.filePath!);

      if (await file.exists()) {
        await file.delete();
      }
    }

    await provider.removeDownload(item.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Download deleted.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _showFilePath(
      BuildContext context,
      String filePath,
      ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151B2D),
          title: const Text(
            'File Location',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SelectableText(
            filePath,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

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
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons
                          .download_for_offline_outlined,
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
                direction:
                DismissDirection.endToStart,
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
                confirmDismiss: (_) async {
                  await _deleteDownload(
                    context,
                    provider,
                    item,
                  );

                  return true;
                },
                child: Container(
                  padding:
                  const EdgeInsets.all(16),
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
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              color:
                              const Color(
                                0xFF635BFF,
                              ).withOpacity(0.15),
                              borderRadius:
                              BorderRadius.circular(
                                14,
                              ),
                            ),
                            child: Icon(
                              item.format == 'MP4'
                                  ? Icons
                                  .video_file_rounded
                                  : Icons
                                  .audio_file_rounded,
                              color:
                              const Color(
                                0xFF8B7FFF,
                              ),
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  item.platform,
                                  style:
                                  const TextStyle(
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
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white60,
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
                                          ? Colors
                                          .greenAccent
                                          : isFailed
                                          ? Colors
                                          .redAccent
                                          : Colors
                                          .orangeAccent,
                                    ),

                                    const SizedBox(
                                      width: 5,
                                    ),

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
                                        FontWeight
                                            .w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white54,
                            ),
                            color:
                            const Color(0xFF1D253B),
                            onSelected: (value) async {
                              if (value == 'open' &&
                                  item.filePath !=
                                      null) {
                                await _openFile(
                                  context,
                                  item.filePath!,
                                );
                              }

                              if (value == 'location' &&
                                  item.filePath !=
                                      null) {
                                await _showFilePath(
                                  context,
                                  item.filePath!,
                                );
                              }

                              if (value == 'delete') {
                                await _deleteDownload(
                                  context,
                                  provider,
                                  item,
                                );
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                if (isCompleted &&
                                    item.filePath !=
                                        null)
                                  const PopupMenuItem(
                                    value: 'open',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .play_circle_outline_rounded,
                                          color:
                                          Colors.white70,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Open File',
                                        ),
                                      ],
                                    ),
                                  ),

                                if (item.filePath !=
                                    null)
                                  const PopupMenuItem(
                                    value: 'location',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .folder_open_rounded,
                                          color:
                                          Colors.white70,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'File Location',
                                        ),
                                      ],
                                    ),
                                  ),

                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons
                                            .delete_outline_rounded,
                                        color:
                                        Colors.redAccent,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Delete',
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                            },
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
                            style:
                            const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],

                      if (isCompleted &&
                          item.filePath != null) ...[
                        const SizedBox(height: 10),

                        GestureDetector(
                          onTap: () {
                            _openFile(
                              context,
                              item.filePath!,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding:
                            const EdgeInsets.all(11),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent
                                  .withOpacity(0.08),
                              borderRadius:
                              BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                Icon(
                                  Icons
                                      .play_circle_outline_rounded,
                                  color:
                                  Colors.greenAccent,
                                  size: 19,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Open File',
                                  style: TextStyle(
                                    color:
                                    Colors.greenAccent,
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      if (isFailed) ...[
                        const SizedBox(height: 10),

                        Container(
                          width: double.infinity,
                          padding:
                          const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.redAccent
                                .withOpacity(0.08),
                            borderRadius:
                            BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons
                                    .error_outline_rounded,
                                color:
                                Colors.redAccent,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Download failed.',
                                  style: TextStyle(
                                    color:
                                    Colors.redAccent,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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