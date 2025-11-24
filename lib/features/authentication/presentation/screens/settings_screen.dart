import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/utils/theme_provider.dart';

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
          // 다크 모드 설정
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
          const Divider(),
        ],
      ),
    );
  }
}
