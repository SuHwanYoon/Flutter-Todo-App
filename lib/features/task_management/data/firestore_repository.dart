import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/task_management/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// FirestoreRepository의 코드 생성기를 사용하기 위해 part 지시어를 추가합니다.
// 이는 firestore_repository.g.dart 파일이 이 파일과 연결되어 있음을 나타냅니다.
part 'firestore_repository.g.dart';

// FirestoreRepository 클래스는 Firestore 데이터베이스와 상호작용하는 역할을 합니다.
// 이 클래스는 작업 추가, 업데이트, 삭제 및 로드와 같은 기능을 제공합니다.
class FirestoreRepository {
  // 생성자에서 Firestore 인스턴스를 주입받습니다.
  // 이는 의존성 주입(Dependency Injection) 패턴을 사용하여 테스트 용이성과 유연성을 높입니다.
  FirestoreRepository(this._firestore);

  // FirebaseFirestore 인스턴스는 Firestore 데이터베이스와 상호작용하는 데 사용됩니다.
  final FirebaseFirestore _firestore;

  // Future는 비동기 작업의 결과를 나타내는 객체입니다.
  // 이 메서드는 비동기적으로 작업을 추가하고, 완료되면 void를 반환합니다.
  // addTask 메서드는 새로운 작업을 Firestore에 추가합니다.
  // userId를 사용하여 특정 사용자의 작업 컬렉션에 작업을 저장합니다.
  // 작업이 추가된 후, Firestore에서 자동으로 생성된 문서 ID를
  // 작업 객체의 id 필드에 업데이트합니다.
  Future<void> addTask({required Task task, required String userId}) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add(task.toJson());

    await docRef.update({'id': docRef.id});
  }

  // updateTask 메서드는 기존 작업을 Firestore에서 업데이트합니다.
  // userId와 taskId를 사용하여 특정 사용자의 특정 작업 문서를 찾아 업데이트합니다.
  // task 객체의 toJson 메서드를 사용하여 작업 데이터를 JSON 형식으로 변환합니다.
  // Firestore의 update 메서드는 지정된 필드만 업데이트하며, 문서가 존재하지 않으면 오류를 발생시킵니다.
  Future<void> updateTask({
    required Task task,
    required String taskId,
    required String userId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update(task.toJson());
  }

  // loadTasks 메서드는 특정 사용자의 작업 목록을 실시간으로 스트림 형태로 제공합니다.
  // Stream객체를 사용하면 사용자가 새로고침을 하지 않아도 UI가 실시간으로 데이터 변경 사항을 반영할 수 있습니다.
  // userId를 사용하여 특정 사용자의 작업 컬렉션을 조회합니다.
  Stream<List<Task>> loadTasks(String userId) {
    // 작업을 날짜(date) 기준으로 descending(내림차순) 정렬합니다.
    // snapshots 메서드는 컬렉션의 실시간 업데이트를 스트림으로 제공합니다.
    // 각 문서 데이터를 Task 객체로 변환하여 리스트로 만듭니다.
    // map 메서드를 사용하여 QuerySnapshot을 List<Task>로 변환합니다.
    // Task.fromJson 메서드는 JSON 데이터를 Task 객체로 변환하는 데 사용됩니다.
    // 최종적으로 Stream<List<Task>> 형태로 반환됩니다.
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList(),
        );
  }

  // loadCompletedTasks 메서드는 특정 사용자의 완료된 작업 목록을 실시간으로 스트림 형태로 제공합니다.
  // userId를 사용하여 특정 사용자의 작업 컬렉션을 조회합니다.
  Stream<List<Task>> loadCompletedTasks(String userId) {
    // where 메서드를 사용하여 isCompleted 필드가 true인 작업만 필터링합니다.
    // 작업을 날짜(date) 기준으로 descending(내림차순) 정렬합니다.
    // snapshots 메서드는 컬렉션의 실시간 업데이트를 스트림으로 제공합니다.
    // 각 문서 데이터를 Task 객체로 변환하여 리스트로 만듭니다.
    // map 메서드를 사용하여 QuerySnapshot을 List<Task>로 변환합니다.
    // Task.fromJson 메서드는 JSON 데이터를 Task 객체로 변환하는 데 사용됩니다.
    // 최종적으로 Stream<List<Task>> 형태로 반환됩니다.
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('isCompleted', isEqualTo: true)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList(),
        );
  }

  // loadIncompleteTasks 메서드는 특정 사용자의 미완료 작업 목록을 실시간으로 스트림 형태로 제공합니다.
  // userId를 사용하여 특정 사용자의 작업 컬렉션을 조회합니다.
  Stream<List<Task>> loadIncompleteTasks(String userId) {
    // where 메서드를 사용하여 isCompleted 필드가 false인 작업만 필터링합니다.
    // 작업을 날짜(date) 기준으로 descending(내림차순) 정렬합니다.
    // snapshots 메서드는 컬렉션의 실시간 업데이트를 스트림으로 제공합니다.
    // 각 문서 데이터를 Task 객체로 변환하여 리스트로 만듭니다.
    // map 메서드를 사용하여 QuerySnapshot을 List<Task>로 변환합니다.
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('isCompleted', isEqualTo: false)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList(),
        );
  }

  // deleteTask 메서드는 특정 사용자의 특정 작업을 Firestore에서 삭제합니다.
  // userId와 taskId를 사용하여 특정 사용자의 특정 작업 문서를 찾아 삭제
  Future<void> deleteTask({
    required String taskId,
    required String userId,
  }) async {
    // delete 메서드는 지정된 문서를 Firestore에서 삭제합니다.
    // await 키워드를 사용하여 비동기 작업이 완료될 때까지 기다립니다.
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  // updateTaskCompletion 메서드는 특정 사용자의 특정 작업의 완료 상태를 업데이트합니다.
  // userId와 taskId를 사용하여 특정 사용자의 특정 작업 문서를 찾아 isCompleted 필드를 업데이트합니다.
  Future<void> updateTaskCompletion({
    required String taskId,
    required String userId,
    required bool isCompleted,
  }) async {
    // update 메서드는 지정된 필드만 업데이트하며, 문서가 존재하지 않으면 오류를 발생시킵니다.
    // isCompleted 필드를 업데이트합니다.
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update({'isCompleted': isCompleted});
  }
}

// Riverpod의 @Riverpod 어노테이션을 사용하여 FirestoreRepository를 제공하는 프로바이더를 정의합니다.
@Riverpod(keepAlive: true)
FirestoreRepository firestoreRepository(Ref ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
}

// 특정 사용자의 작업 스트림을 제공하는 프로바이더를 정의합니다.
// userId를 매개변수로 받아 해당 사용자의 작업 스트림을 반환합니다.
// 이 프로바이더는 userId가 변경될 때마다 새로운 스트림을 생성합니다.
// 예를 들어, 사용자가 로그인하거나 로그아웃할 때 userId가 변경될 수 있습니다.
@riverpod
Stream<List<Task>> loadTasks(Ref ref, String userId) {
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return firestoreRepository.loadTasks(userId);
}

// 특정 사용자의 완료된 작업 스트림을 제공하는 프로바이더를 정의합니다.
// userId를 매개변수로 받아 해당 사용자의 완료된 작업 스트림을 반환합니다.
// 이 프로바이더는 userId가 변경될 때마다 새로운 스트림을 생성합니다.
@riverpod
Stream<List<Task>> loadCompletedTasks(Ref ref, String userId) {
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return firestoreRepository.loadCompletedTasks(userId);
}

// 특정 사용자의 미완료 작업 스트림을 제공하는 프로바이더를 정의합니다.
// userId를 매개변수로 받아 해당 사용자의 미완료 작업 스트림을 반환합니다.
@riverpod
Stream<List<Task>> loadIncompleteTasks(Ref ref, String userId) {
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return firestoreRepository.loadIncompleteTasks(userId);
}




