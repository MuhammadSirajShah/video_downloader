import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

import '../../providers/downloader_provider.dart';
import '../../services/downloader_service.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  Future<void> _openFile(
      BuildContext context,
      DownloadItem item,
      ) async {
    final filePath = item.filePath;

    if (filePath == null ||
        filePath.trim().isEmpty) {
      _showMessage(
        context,
        'File location is not available.',
      );
      return;
    }

    final file = File(filePath);

    if (!await file.exists()) {
      if (!context.mounted) {
        return;
      }

      _showMessage(
        context,
        'This file no longer exists.',
      );
      return;
    }

    if (!context.mounted) {
      return;
    }

    await OpenFilex.open(filePath);
  }

  Future<void> _deleteDownload(
      BuildContext context,
      DownloadItem item,
      ) async {
    final provider =
    context.read<DownloaderProvider>();

    final filePath = item.filePath;

    if (filePath != null &&
        filePath.trim().isNotEmpty) {
      final downloaderService =
      DownloaderService();

      await downloaderService.deleteFile(
        filePath,
      );
    }

    await provider.removeDownload(
      item.id,
    );

    if (!context.mounted) {
      return;
    }

    _showMessage(
      context,
      'Download deleted.',
    );
  }

  Future<void> _showFileLocation(
      BuildContext context,
      DownloadItem item,
      ) async {
    final filePath = item.filePath;

    if (filePath == null ||
        filePath.trim().isEmpty) {
      _showMessage(
        context,
        'File location is not available.',
      );
      return;
    }

    final file = File(filePath);

    if (!await file.exists()) {
      if (!context.mounted) {
        return;
      }

      _showMessage(
        context,
        'This file no longer exists.',
      );
      return;
    }

    if (!context.mounted) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          const Color(0xFF151B2D),
          title: const Text(
            'File Location',
            style: TextStyle(
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
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      DownloadItem item,
      ) async {
    final confirmed =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          const Color(0xFF151B2D),
          title: const Text(
            'Delete Download?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'This will remove the download from the app and delete the saved file.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.redAccent,
                foregroundColor:
                Colors.white,
              ),
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        !context.mounted) {
      return;
    }

    await _deleteDownload(
      context,
      item,
    );
  }

  Future<void> _clearAll(
      BuildContext context,
      ) async {
    final provider =
    context.read<DownloaderProvider>();

    if (provider.downloads.isEmpty) {
      return;
    }

    final confirmed =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          const Color(0xFF151B2D),
          title: const Text(
            'Clear All Downloads?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'All download records will be removed from the app.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.redAccent,
                foregroundColor:
                Colors.white,
              ),
              child: const Text(
                'Clear All',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        !context.mounted) {
      return;
    }

    await provider.clearDownloads();

    if (!context.mounted) {
      return;
    }

    _showMessage(
      context,
      'Download history cleared.',
    );
  }

  void _showMessage(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  Color _getStatusColor(
      String status,
      ) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.greenAccent;

      case 'failed':
        return Colors.redAccent;

      case 'downloading':
        return const Color(0xFF635BFF);

      case 'preparing':
        return Colors.orangeAccent;

      default:
        return Colors.white54;
    }
  }

  IconData _getStatusIcon(
      String status,
      ) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_rounded;

      case 'failed':
        return Icons.error_rounded;

      case 'downloading':
        return Icons.downloading_rounded;

      case 'preparing':
        return Icons.hourglass_top_rounded;

      default:
        return Icons.info_rounded;
    }
  }

  String _getTitle(
      DownloadItem item,
      ) {
    final platform =
    item.platform.trim();

    if (item.quality != null &&
        item.quality!.trim().isNotEmpty &&
        item.format.toUpperCase() ==
            'MP4') {
      return '$platform • ${item.quality}';
    }

    return '$platform • ${item.format}';
  }

  String _getProgressText(
      DownloadItem item,
      ) {
    final progress =
    (item.progress * 100)
        .clamp(0.0, 100.0)
        .toStringAsFixed(0);

    return '$progress%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor:
        const Color(0xFF0B1020),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Downloads',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<DownloaderProvider>(
            builder: (
                context,
                provider,
                child,
                ) {
              if (provider.downloads.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                onPressed: () {
                  _clearAll(context);
                },
                tooltip: 'Clear all',
                icon: const Icon(
                  Icons.delete_sweep_rounded,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<DownloaderProvider>(
        builder: (
            context,
            provider,
            child,
            ) {
          final downloads =
              provider.downloads;

          if (downloads.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: downloads.length,
            separatorBuilder:
                (context, index) =>
            const SizedBox(height: 12),
            itemBuilder:
                (context, index) {
              final item =
              downloads[index];

              return _buildDownloadCard(
                context,
                item,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration:
              BoxDecoration(
                color:
                const Color(0xFF151B2D),
                borderRadius:
                BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.download_rounded,
                size: 44,
                color:
                Color(0xFF635BFF),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Downloads Yet',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your downloaded files will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadCard(
      BuildContext context,
      DownloadItem item,
      ) {
    final statusColor =
    _getStatusColor(item.status);

    final statusIcon =
    _getStatusIcon(item.status);

    final isDownloading =
        item.status.toLowerCase() ==
            'downloading';

    final isCompleted =
        item.status.toLowerCase() ==
            'completed';

    final isFailed =
        item.status.toLowerCase() ==
            'failed';

    return Dismissible(
      key: ValueKey(item.id),
      direction:
      DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await _confirmDelete(
          context,
          item,
        );

        return false;
      },
      background: Container(
        alignment:
        Alignment.centerRight,
        padding:
        const EdgeInsets.only(
          right: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius:
          BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
        ),
      ),
      child: Container(
        padding:
        const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
          const Color(0xFF151B2D),
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
                  width: 52,
                  height: 52,
                  decoration:
                  BoxDecoration(
                    color:
                    const Color(0xFF635BFF)
                        .withValues(
                      alpha: 0.12,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: Icon(
                    item.format
                        .toUpperCase() ==
                        'MP3'
                        ? Icons
                        .audio_file_rounded
                        : Icons
                        .video_file_rounded,
                    color:
                    const Color(
                      0xFF635BFF,
                    ),
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
                        _getTitle(item),
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        item.url,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          color:
                          Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Icon(
                            statusIcon,
                            size: 16,
                            color:
                            statusColor,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            item.status,
                            style:
                            TextStyle(
                              color:
                              statusColor,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          if (isDownloading) ...[
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              _getProgressText(
                                item,
                              ),
                              style:
                              const TextStyle(
                                color:
                                Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (isDownloading) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius:
                BorderRadius.circular(10),
                child:
                LinearProgressIndicator(
                  value: item.progress
                      .clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor:
                  Colors.white10,
                  color:
                  const Color(0xFF635BFF),
                ),
              ),
            ],

            if (isFailed) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(10),
                decoration:
                BoxDecoration(
                  color:
                  Colors.redAccent
                      .withValues(
                    alpha: 0.08,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                ),
                child: const Text(
                  'This download could not be completed.',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                  ),
                ),
              ),
            ],

            if (isCompleted) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton
                        .icon(
                      onPressed: () {
                        _openFile(
                          context,
                          item,
                        );
                      },
                      icon: const Icon(
                        Icons
                            .play_arrow_rounded,
                        size: 18,
                      ),
                      label:
                      const Text('Open'),
                      style:
                      OutlinedButton
                          .styleFrom(
                        foregroundColor:
                        Colors.white,
                        side:
                        const BorderSide(
                          color:
                          Colors.white24,
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton
                        .icon(
                      onPressed: () {
                        _showFileLocation(
                          context,
                          item,
                        );
                      },
                      icon: const Icon(
                        Icons
                            .folder_open_rounded,
                        size: 18,
                      ),
                      label:
                      const Text('Location'),
                      style:
                      OutlinedButton
                          .styleFrom(
                        foregroundColor:
                        Colors.white,
                        side:
                        const BorderSide(
                          color:
                          Colors.white24,
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}