import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';

// 기존클래스에 추가할 확장
// 이 확장은 AsyncValue타입에 한해서 적용한다
// riverpod로 AsyncValue를 참조하면 이 확장의 메서드를 사용할 수 있다.
extension AsyncValueUi on AsyncValue {
  // BuildContext를 매개변수로 받는 메서드
  void showAlertDialogOnError(BuildContext context) {
    // 로딩중이 아니고 에러가 발생했을 경우
    if (!isLoading && hasError) {
      // _errorMessage 메서드를 통해 에러 메시지를 가져온다.
      final message = _errorMessage(error);
      // 다이얼로그를 보여준다.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          // 에러 아이콘
          icon: const Icon(Icons.error, color: Colors.red, size: 40),
          // 에러 메시지를 보여주는 타이틀
          title: Text(message, style: Appstyles.normalTextStyle),
          // 다이얼로그 액션
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 확인 버튼
                // ElevatedButton은 눌렀을 때 약간의 음영 효과가 있는 버튼
                // onPressed는 버튼이 눌렸을 때 실행되는 콜백 함수
                // Navigator.pop(context)는 현재 화면을 닫는 역할
                // child는 버튼 안에 들어가는 위젯 
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close', style: Appstyles.normalTextStyle),
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
// 에러 객체를 매개변수로 받아서 에러 메시지를 문자열로 반환한다.
String _errorMessage(Object? error) {
  // 만약 에러가 FirebaseAuthException 타입이라면
  if (error is FirebaseAuthException) {
    // null이 아니면 에러 메시지를 반환 null이면 에러를 문자열로 변환하여 반환한다.
    // 이항연산자 ??
    return error.message ?? error.toString();
  } else {
    // 그 외의 경우 에러를 문자열로 변환하여 반환한다.
    return error.toString();
  }
}