import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// AsyncValueWidget는 비동기 상태(loading, error, data)를 처리하는 위젯입니다.
// 이 위젯은 AsyncValue의 상태에 따라 적절한 UI를 렌더링합니다.
// 예를 들어, 로딩 중일 때는 로딩 스피너를 표시하고,
// 오류가 발생했을 때는 오류 메시지를 표시하며,
// 데이터가 성공적으로 로드되었을 때는 실제 데이터를 표시합니다.
// StatefulWidget이 아닌 StatelessWidget을 상속받아 상태를 직접 관리하지 않습니다.
class AsyncValueWidget<T> extends StatelessWidget {
  
  // 생성자에서 AsyncValue와 데이터를 렌더링할 콜백 함수를 받습니다.
  const AsyncValueWidget({super.key, required this.value, required this.data});
  // AsyncValue는 Riverpod에서 제공하는 비동기 상태를 나타내는 클래스입니다.
  // 이 클래스는 로딩, 오류, 데이터 상태를 포함할 수 있습니다.
  // data 콜백 함수는 데이터가 성공적으로 로드되었을 때 호출됩니다.
  final AsyncValue<T> value;
  final Widget Function(T data) data;

  // build 메서드는 위젯의 UI를 구성합니다.
  // build 메서드가 필수적으로 override 되어야 하는 이유는
  // StatelessWidget이 상태를 가지지 않기 때문에, UI를 어떻게 그릴지
  // 정의하는 유일한 방법이기 때문입니다.
  @override
  Widget build(BuildContext context) {
    return value.when(
      // 로딩 상태일 때 CircularProgressIndicator를 중앙에 표시합니다.
      loading: () => const Center(child: CircularProgressIndicator()),
      // 오류 상태일 때 오류 메시지를 중앙에 표시합니다.
      error: (error, stack) => Center(child: Text('Error: $error')),
      // 데이터가 성공적으로 로드되었을 때 표시할 위젯을 정의합니다.
      data: data,
    );
  }
}