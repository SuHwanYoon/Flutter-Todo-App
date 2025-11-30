import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/authentication/presentation/screens/delete_account_screen.dart';
import 'package:flutter_todo_app/utils/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: Text(isDarkMode ? 'Dark theme enabled' : 'Light theme enabled'),
            secondary: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: isDarkMode ? Colors.amber : Colors.orange,
            ),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(appThemeModeProvider.notifier).toggleTheme();
            },
          ),

          const SizedBox(height: 16),

          // Account Section
          _buildSectionHeader(context, 'Account'),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Delete Account'),
            subtitle: const Text('Permanently delete your account'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DeleteAccountScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Support Section
          _buildSectionHeader(context, 'Support'),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Contact Us'),
            subtitle: const Text('Get help or send feedback'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl('https://forms.gle/MCcaaTJ2bKhyNp6a7'), 
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            subtitle: const Text('Read our privacy policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl('https://doc-hosting.flycricket.io/oneulyi-halil-privacy-policy/f8f480a5-fa2d-4c65-b550-32bcb6f3b5b3/privacy'), 
          ),

          const SizedBox(height: 16),

          // Developer Section
          _buildSectionHeader(context, 'Developer'),
          const ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Developer Email'),
            subtitle: Text('suhwan6@gmail.com'), 
          ),
        ],
      ),
    );
  }

  // 섹션 헤더 위젯
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // URL 열기
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

}
