import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';

// 기존클래스에 추가할 확장
// 이 확장은 AsyncValue타입에 한해서 적용한다
extension AsyncValueUi on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      final message = _errorMessage(error);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.error, color: Colors.red, size: 40),
          title: Text(message, style: Appstyles.normalTextStyle),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK', style: Appstyles.normalTextStyle),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

// FirebaseAuthException의 errorMessage
String _errorMessage(Object? error) {
  if (error is FirebaseAuthException) {
    return error.message ?? error.toString();
  } else {
    return error.toString();
  }
}
