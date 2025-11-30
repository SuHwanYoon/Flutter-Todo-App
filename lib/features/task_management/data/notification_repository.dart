import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/task_management/domain/task_notification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_repository.g.dart';

class NotificationRepository {
  const NotificationRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Get notifications collection reference for a user
  CollectionReference<TaskNotification> _notificationsRef(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .withConverter<TaskNotification>(
          fromFirestore: (snapshot, _) =>
              TaskNotification.fromJson(snapshot.data()!),
          toFirestore: (notification, _) => notification.toJson(),
        );
  }

  // Add a notification
  Future<void> addNotification({
    required String userId,
    required TaskNotification notification,
  }) async {
    final docRef = _notificationsRef(userId).doc();
    final notificationWithId = notification.copyWith(id: docRef.id);
    await docRef.set(notificationWithId);
  }

  // Get notification for a specific task
  Future<TaskNotification?> getNotificationForTask({
    required String userId,
    required String taskId,
  }) async {
    final querySnapshot = await _notificationsRef(userId)
        .where('taskId', isEqualTo: taskId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return querySnapshot.docs.first.data();
  }

  // Stream of notifications for a specific task
  Stream<List<TaskNotification>> watchNotificationsForTask({
    required String userId,
    required String taskId,
  }) {
    return _notificationsRef(userId)
        .where('taskId', isEqualTo: taskId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Update notification
  Future<void> updateNotification({
    required String userId,
    required String notificationId,
    required TaskNotification notification,
  }) async {
    await _notificationsRef(userId).doc(notificationId).update(
          notification.toJson(),
        );
  }

  // Delete notification
  Future<void> deleteNotification({
    required String userId,
    required String notificationId,
  }) async {
    await _notificationsRef(userId).doc(notificationId).delete();
  }

  // Delete all notifications for a task
  Future<void> deleteNotificationsForTask({
    required String userId,
    required String taskId,
  }) async {
    final querySnapshot = await _notificationsRef(userId)
        .where('taskId', isEqualTo: taskId)
        .get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Mark notification as triggered
  Future<void> markAsTriggered({
    required String userId,
    required String notificationId,
  }) async {
    await _notificationsRef(userId).doc(notificationId).update({
      'isTriggered': true,
    });
  }

  // Get all notifications for a user (for rescheduling on login)
  Future<List<TaskNotification>> getAllNotifications({
    required String userId,
  }) async {
    final querySnapshot = await _notificationsRef(userId).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Batch delete notifications for multiple tasks
  Future<void> batchDeleteNotificationsForTasks({
    required String userId,
    required List<String> taskIds,
  }) async {
    if (taskIds.isEmpty) return;

    // Firestore's 'whereIn' query supports up to 30 elements.
    const chunkSize = 30;
    for (var i = 0; i < taskIds.length; i += chunkSize) {
      final chunk = taskIds.sublist(
          i, i + chunkSize > taskIds.length ? taskIds.length : i + chunkSize);

      final querySnapshot =
          await _notificationsRef(userId).where('taskId', whereIn: chunk).get();

      if (querySnapshot.docs.isEmpty) continue;

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepository(FirebaseFirestore.instance);
}

// StreamProvider to watch notification for a specific task
@riverpod
Stream<TaskNotification?> taskNotification(
  Ref ref, {
  required String userId,
  required String taskId,
}) {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository
      .watchNotificationsForTask(userId: userId, taskId: taskId)
      .map((notifications) => notifications.isEmpty ? null : notifications.first);
}

// StreamProvider to load all notifications for a user
@riverpod
Stream<List<TaskNotification>> loadNotifications(Ref ref, String userId) {
  final firestore = FirebaseFirestore.instance;
  return firestore
      .collection('users')
      .doc(userId)
      .collection('notifications')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => TaskNotification.fromJson(doc.data()))
          .toList());
}
