import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
const SettingsScreen({super.key});

void _showAboutDialog(BuildContext context) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF151B2D),
      title: const Text('Video Downloader', style: TextStyle(
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.bold,),),
      content: const Text(
        'A simple and modern media downloader app '
            'for supported sources and permitted content.', style: TextStyle(
        color: Color(0xFFBDBDBD),height: 1.5,),),
      actions: [
        TextButton(
          onPressed: () {Navigator.pop(context);},
          child: const Text('Close'),
        ),
      ],
    );
    },
  );
}
void _showDownloadFolder(BuildContext context) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF151B2D),
      title: const Text('Download Folder', style: TextStyle(
        color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold,
      ),
      ),
      content: const Text(
        'Downloaded files are currently stored '
            'inside the application documents directory.', style: TextStyle(
        color: Color(0xFFBDBDBD), height: 1.5,
      ),
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
    },
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Settings', style: TextStyle(
      fontWeight: FontWeight.bold,),
    ),
      backgroundColor: const Color(0xFF0B1020),
      foregroundColor: const Color(0xFFFFFFFF),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // ==========================================
        //                 APP HEADER
        // ==========================================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF151B2D),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x1AFFFFFF),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: const Color(0x26635BFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.download_rounded, color: Color(0xFF8B7FFF),
                  size: 30,),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Video Downloader', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,),
                    ),
                    SizedBox(height: 5),
                    Text('Download manager', style: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 13,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        // ==========================================
        //            DOWNLOAD SECTION
        // ==========================================

        const Text('Downloads', style: TextStyle(
          color: Color(0xFFBDBDBD),
          fontSize: 13, fontWeight: FontWeight.w600,),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF151B2D),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Color(0x1AFFFFFF),
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: const Color(0x1F635BFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.folder_rounded, color: Color(0xFF8B7FFF),
                  ),
                ),
                title: const Text('Download Folder', style: TextStyle(
                  fontWeight: FontWeight.w600,),
                ),
                subtitle: const Text('Application storage', style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 12,
                ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFF777777),
                ),
                onTap: () {
                  _showDownloadFolder(context);
                  },
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        // ==========================================
        //               APPEARANCE
       // ==========================================
        const Text('Appearance', style: TextStyle(
          color: Color(0xFFBDBDBD),
          fontSize: 13,
          fontWeight: FontWeight.w600,),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF151B2D),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0x1AFFFFFF),
            ),
          ),
          child: const ListTile(
            leading: Icon(Icons.dark_mode_rounded, color: Color(0xFF8B7FFF),
            ),
            title: Text('Theme', style: TextStyle(
              fontWeight: FontWeight.w600,),
            ),
            subtitle: Text('Dark mode', style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 12,),
            ),
            trailing: Text('Dark', style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 13,),
            ),
          ),
        ),
        const SizedBox(height: 25),

       // ==========================================
      //               ABOUT
     // ==========================================

        const Text('About', style: TextStyle(
          color: Color(0xFFBDBDBD),
          fontSize: 13, fontWeight: FontWeight.w600,),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF151B2D),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0x1AFFFFFF),
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF8B7FFF),),
                title: const Text('About App', style: TextStyle(
                  fontWeight: FontWeight.w600,),
                ), trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF777777),
              ),
                onTap: () {_showAboutDialog(context);
                  },
              ),
              const Divider(
                height: 1,
                color: Color(0x1AFFFFFF),
              ),
              const ListTile(
                leading: Icon(
                  Icons.verified_outlined,
                  color: Color(0xFF8B7FFF),
                ),
                title: Text('App Version', style: TextStyle(
                  fontWeight: FontWeight.w600,),
                ), trailing: Text('1.0.0', style: TextStyle(
                color: Color(0xFF999999), fontSize: 13,),
              ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 35),
        // ==========================================
       //                FOOTER
        // ==========================================
        const Center(
          child: Text('Video Downloader', style: TextStyle(
            color: Color(0xFF555555),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text('Use only with content you are permitted to download.',
            textAlign: TextAlign.center, style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 11,),),
        ),
      ],
    ),
  );
}
}

