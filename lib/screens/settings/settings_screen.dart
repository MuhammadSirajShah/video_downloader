import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  String _downloadFolder = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadDownloadFolder();
  }

  Future<void> _loadDownloadFolder() async {
    try {
      final directory =
      await getApplicationDocumentsDirectory();

      final path =
          '${directory.path}/downloads';

      if (!mounted) {
        return;
      }

      setState(() {
        _downloadFolder = path;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _downloadFolder =
        'Unable to determine folder.';
      });
    }
  }

  void _showAboutDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          const Color(0xFF151B2D),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration:
                BoxDecoration(
                  color:
                  const Color(0xFF635BFF)
                      .withValues(
                    alpha: 0.15,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
                child: const Icon(
                  Icons
                      .download_rounded,
                  color:
                  Color(0xFF635BFF),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Video Downloader',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'A simple media downloader app designed to help users process supported media links and manage their downloaded files.',
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please download only content that you have permission to download and use.',
                style: TextStyle(
                  color: Colors.white54,
                  height: 1.5,
                  fontSize: 12,
                ),
              ),
            ],
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

  void _showDownloadFolder() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          const Color(0xFF151B2D),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text(
            'Downloads Folder',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SelectableText(
            _downloadFolder,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
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

  void _showResponsibleUse() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          const Color(0xFF151B2D),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text(
            'Responsible Use',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: Text(
              'Use this application responsibly. Only process and download media when you have the necessary rights or permission to do so.\n\n'
                  'Availability of media information and downloadable formats depends on the supported source and its permitted access.\n\n'
                  'The application does not grant ownership or permission to use content belonging to other people or services.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.6,
              ),
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
                'Got it',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(
      String title,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      List<Widget> children,
      ) {
    return Container(
      width: double.infinity,
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
        children: children,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color:
          const Color(0xFF635BFF)
              .withValues(
            alpha: 0.12,
          ),
          borderRadius:
          BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color:
          const Color(0xFF635BFF),
          size: 21,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: Padding(
        padding:
        const EdgeInsets.only(
          top: 4,
        ),
        child: Text(
          subtitle,
          maxLines: 2,
          overflow:
          TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
            height: 1.3,
          ),
        ),
      ),
      trailing: trailing ??
          const Icon(
            Icons
                .arrow_forward_ios_rounded,
            color: Colors.white24,
            size: 15,
          ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor:
        const Color(0xFF0B1020),
        foregroundColor:
        Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding:
          const EdgeInsets.all(20),
          children: [
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient:
                const LinearGradient(
                  begin:
                  Alignment.topLeft,
                  end:
                  Alignment.bottomRight,
                  colors: [
                    Color(0xFF151B2D),
                    Color(0xFF11172A),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
                border: Border.all(
                  color: Colors.white10,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration:
                    BoxDecoration(
                      color:
                      const Color(
                        0xFF635BFF,
                      ).withValues(
                        alpha: 0.15,
                      ),
                      borderRadius:
                      BorderRadius
                          .circular(
                        17,
                      ),
                    ),
                    child: const Icon(
                      Icons
                          .download_rounded,
                      color:
                      Color(0xFF635BFF),
                      size: 31,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          'Video Downloader',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color:
                            Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            _buildSectionTitle(
              'Downloads',
            ),

            _buildSettingsCard(
              [
                _buildSettingsTile(
                  icon:
                  Icons.folder_rounded,
                  title:
                  'Downloads Folder',
                  subtitle:
                  'View where downloaded files are stored.',
                  onTap:
                  _showDownloadFolder,
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSectionTitle(
              'Appearance',
            ),

            _buildSettingsCard(
              [
                _buildSettingsTile(
                  icon:
                  Icons.dark_mode_rounded,
                  title:
                  'Dark Theme',
                  subtitle:
                  'The application currently uses a dark interface.',
                  trailing:
                  const Icon(
                    Icons.check_circle_rounded,
                    color:
                    Color(0xFF635BFF),
                    size: 22,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSectionTitle(
              'Information',
            ),

            _buildSettingsCard(
              [
                _buildSettingsTile(
                  icon:
                  Icons.info_outline_rounded,
                  title: 'About App',
                  subtitle:
                  'Application information and version details.',
                  onTap:
                  _showAboutDialog,
                ),
                Divider(
                  height: 1,
                  color: Colors.white10,
                  indent: 74,
                  endIndent: 16,
                ),
                _buildSettingsTile(
                  icon:
                  Icons.security_rounded,
                  title:
                  'Responsible Use',
                  subtitle:
                  'Important information about using the downloader.',
                  onTap:
                  _showResponsibleUse,
                ),
              ],
            ),

            const SizedBox(height: 30),

            Container(
              padding:
              const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                const Color(0xFF151B2D),
                borderRadius:
                BorderRadius.circular(
                  16,
                ),
              ),
              child: const Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons
                        .verified_user_outlined,
                    color:
                    Color(0xFF635BFF),
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Use this application only with media you are authorized to access and download.',
                      style: TextStyle(
                        color:
                        Colors.white38,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Center(
              child: Column(
                children: [
                  Text(
                    'Video Downloader',
                    style: TextStyle(
                      color:
                      Colors.white24,
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color:
                      Colors.white12,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}