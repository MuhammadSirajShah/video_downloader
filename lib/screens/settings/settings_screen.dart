import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ==========================================
  // ABOUT DIALOG
  // ==========================================

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151B2D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Video Downloader',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'A simple and modern media downloader app '
                'for supported sources and permitted content.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.5,
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

  // ==========================================
  // DOWNLOAD FOLDER DIALOG
  // ==========================================

  void _showDownloadFolder(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151B2D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Download Folder',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Downloaded files are currently stored '
                'inside the application documents directory.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // SETTINGS ITEM
  // ==========================================

  Widget _settingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      leading: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF635BFF).withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF8B7FFF),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
      ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white38,
          ),
      onTap: onTap,
    );
  }

  // ==========================================
  // SECTION TITLE
  // ==========================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),

      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0B1020),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ==========================================
          // APP HEADER
          // ==========================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF151B2D),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white10,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF635BFF).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.download_rounded,
                    color: Color(0xFF8B7FFF),
                    size: 30,
                  ),
                ),

                const SizedBox(width: 15),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Video Downloader',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Download manager',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ==========================================
          // DOWNLOADS
          // ==========================================

          _sectionTitle('Downloads'),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF151B2D),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white10,
              ),
            ),
            child: _settingsItem(
              icon: Icons.folder_rounded,
              title: 'Download Folder',
              subtitle: 'Application storage',
              onTap: () {
                _showDownloadFolder(context);
              },
            ),
          ),

          const SizedBox(height: 25),

          // ==========================================
          // APPEARANCE
          // ==========================================

          _sectionTitle('Appearance'),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF151B2D),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white10,
              ),
            ),
            child: _settingsItem(
              icon: Icons.dark_mode_rounded,
              title: 'Theme',
              subtitle: 'Dark mode',
              trailing: const Text(
                'Dark',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ==========================================
          // ABOUT
          // ==========================================

          _sectionTitle('About'),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF151B2D),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white10,
              ),
            ),
            child: Column(
              children: [
                _settingsItem(
                  icon: Icons.info_outline_rounded,
                  title: 'About App',
                  subtitle: 'Information about this app',
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),

                const Divider(
                  height: 1,
                  color: Colors.white10,
                  indent: 16,
                  endIndent: 16,
                ),

                _settingsItem(
                  icon: Icons.verified_outlined,
                  title: 'App Version',
                  subtitle: 'Current installed version',
                  trailing: const Text(
                    '1.0.0',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 35),

          // ==========================================
          // FOOTER
          // ==========================================

          const Center(
            child: Text(
              'Video Downloader',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Center(
            child: Text(
              'Use only with content you are permitted to download.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white24,
                fontSize: 11,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}