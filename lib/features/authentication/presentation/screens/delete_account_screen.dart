import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/authentication/presentation/controllers/auth_controller.dart';

class DeleteAccountScreen extends ConsumerWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Center(
              child: Text(
                'Delete Your Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Warning messages
            _buildWarningItem(
              context,
              Icons.task_alt,
              'All your tasks will be permanently deleted',
            ),
            const SizedBox(height: 12),
            _buildWarningItem(
              context,
              Icons.notifications_off,
              'All scheduled notifications will be cancelled',
            ),
            const SizedBox(height: 12),
            _buildWarningItem(
              context,
              Icons.no_accounts,
              'Your account cannot be recovered',
            ),

            const Spacer(),

            // Delete Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _showDeleteAccountDialog(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningItem(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, color: Colors.red, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    final passwordController = TextEditingController();
    String? errorMessage;
    bool isLoading = false;
    bool obscurePassword = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Enter Password'),
          icon: const Icon(Icons.lock, color: Colors.red),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please enter your password to confirm account deletion.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            setDialogState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                  ),
                ),
                onChanged: (_) {
                  if (errorMessage != null) {
                    setDialogState(() {
                      errorMessage = null;
                    });
                  }
                },
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
              if (isLoading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final password = passwordController.text.trim();
                      if (password.isEmpty) {
                        setDialogState(() {
                          errorMessage = 'Please enter your password';
                        });
                        return;
                      }

                      // 로딩 시작
                      setDialogState(() {
                        isLoading = true;
                        errorMessage = null;
                      });

                      // Delete account with password
                      await ref.read(authControllerProvider.notifier).deleteAccount(
                            password: password,
                          );

                      // Check for errors
                      final state = ref.read(authControllerProvider);
                      if (state.hasError) {
                        final error = state.error.toString();
                        // 콘솔에 에러 출력
                        debugPrint('=== DELETE ACCOUNT ERROR ===');
                        debugPrint('Error: $error');
                        debugPrint('============================');

                        String newErrorMessage;
                        if (error.contains('wrong-password') ||
                            error.contains('invalid-credential')) {
                          newErrorMessage = 'Incorrect password. Please try again.';
                        } else {
                          newErrorMessage = 'Error: $error';
                        }
                        setDialogState(() {
                          isLoading = false;
                          errorMessage = newErrorMessage;
                        });
                      }
                      // 성공 시 authStateChange로 인해 자동으로 로그인 화면으로 이동
                    },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
