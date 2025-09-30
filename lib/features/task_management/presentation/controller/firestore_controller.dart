import 'dart:async';

import 'package:flutter_todo_app/features/task_management/data/firestore_repository.dart';
import 'package:flutter_todo_app/features/task_management/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_controller.g.dart';

// FirestoreController는 firestore_repository.dart의 FirestoreRepository를 사용하여
// Firestore 데이터베이스와 간접적으로 상호작용합니다.
// AsyncNotifier를 상속하여 비동기 상태 관리를 제공합니다.
@riverpod
class FirestoreController extends _$FirestoreController {
  @override
  FutureOr<void> build() {
    // 초기화 작업이 필요하면 여기에 작성합니다.
    throw UnimplementedError();
  }

  // addTask 메서드는 새로운 작업을 Firestore에 추가합니다.
  // userId를 사용하여 특정 사용자의 작업 컬렉션에 작업을 저장합니다.
  // task 객체는 추가할 작업의 데이터를 포함합니다.
  Future<void> addTask({required String userId, required Task task}) async {
    // 상태를 로딩 상태로 설정합니다.
    state = const AsyncLoading();
    // FirestoreRepository 인스턴스를 가져옵니다.
    final firestoreRepository = ref.read(firestoreRepositoryProvider);
    // guard 메서드의 기능은 다음과 같습니다:
    // 1. 비동기 작업을 수행합니다.
    // 2. 작업이 성공하면 상태를 AsyncData로 업데이트합니다.
    // 3. 작업이 실패하면 상태를 AsyncError로 업데이트합니다.
    // guard 메서드를 사용하여 비동기 작업을 수행하고,
    // 작업이 완료되면 상태를 업데이트합니다.
    state = await AsyncValue.guard(
      () => firestoreRepository.addTask(userId: userId, task: task),
    );
  }

  // updateTask 메서드는 기존 작업을 Firestore에서 업데이트합니다.
  // userId와 taskId를 사용하여 특정 사용자의 특정 작업 문서를 찾아 업데이트합니다.
  // task 객체는 업데이트할 작업의 새로운 데이터를 포함합니다.
  Future<void> updateTask({
    required String userId,
    required String taskId,
    required Task task,
  }) async {
    state = const AsyncLoading();
    final firestoreRepository = ref.read(firestoreRepositoryProvider);
    state = await AsyncValue.guard(
      () => firestoreRepository.updateTask(
        userId: userId,
        taskId: taskId,
        task: task,
      ),
    );
  }

  // deleteTask 메서드는 Firestore에서 특정 작업을 삭제합니다.
  // userId와 taskId를 사용하여 특정 사용자의 특정 작업 문서를 찾아 삭제합니다.
  Future<void> deleteTask({
    required String userId,
    required String taskId,
  }) async {
    state = const AsyncLoading();
    final firestoreRepository = ref.read(firestoreRepositoryProvider);
    state = await AsyncValue.guard(
      () => firestoreRepository.deleteTask(userId: userId, taskId: taskId),
    );
  }
}
