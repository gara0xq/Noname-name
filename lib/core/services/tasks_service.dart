import 'dart:developer';
import 'dio_client.dart';
import '../../features/parent/home/model/task_model.dart';

class TasksService {
  Future<List<TaskModel>> getAllTasks() async {
    const String uri = '/user/parent/getTasks';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.get(uri: uri);

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData.containsKey('tasks')) {
          final List<dynamic> tasksJson = responseData['tasks'];
          final tasks = tasksJson
              .map((taskMap) => TaskModel.fromJson(taskMap))
              .toList();

          print(' getAllTasks: Found ${tasks.length} tasks');
          if (tasks.isNotEmpty) {
            print(
              ' Sample task: ${tasks.first.title} - Status: ${tasks.first.status}',
            );
          }

          return tasks;
        }
      }
      return [];
    } catch (e) {
      log('Error fetching all tasks: $e');
      rethrow;
    }
  }

  Future<List<TaskModel>> getChildTasks(String childCode) async {
    const String uri = '/user/parent/getChildTasks';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.getWithBody(
        uri: uri,
        data: {"childcode": childCode},
      );

      if (response.statusCode == 200 && response.data != null) {
        print(' getChildTasks Response: ${response.data}');

        final Map<String, dynamic> responseData = response.data;

        if (responseData.containsKey('task')) {
          final List<dynamic> tasksJson = responseData['task'];
          final tasks = tasksJson
              .map((taskMap) => TaskModel.fromJson(taskMap))
              .toList();

          print(
            ' getChildTasks: Found ${tasks.length} tasks for child $childCode',
          );
          return tasks;
        }
      }
      return [];
    } catch (e) {
      log('Error fetching child tasks: $e');
      rethrow;
    }
  }

  Future<TaskModel?> getTaskById(String taskId) async {
    final String uri = '/user/parent/getCurrentTask/$taskId';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.get(uri: uri);

      if (response.statusCode == 200 && response.data != null) {
        print(' getTaskById Response for $taskId:');
        print(response.data);

        final Map<String, dynamic> responseData = response.data;

        if (responseData.containsKey('task')) {
          final Map<String, dynamic> taskData = responseData['task'];
          return TaskModel.fromJson(taskData);
        } else {
          return TaskModel.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      log('Error fetching task by id: $e');
      rethrow;
    }
  }

  Future<bool> addTask({
    required String title,
    required String description,
    required int points,
    required String childCode,
    required String punishment,
    String? expireDate,
  }) async {
    const String uri = '/user/parent/add_task';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.post(
        uri: uri,
        data: {
          "title": title,
          "description": description,
          "points": points,
          "code": childCode,
          "punishment": punishment,
          if (expireDate != null && expireDate.isNotEmpty)
            "expire_date": expireDate,
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('Error adding task: $e');
      rethrow;
    }
  }

  Future<bool> approveTask(String taskId) async {
    const String uri = '/user/parent/approve';   
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.post(
        uri: uri,
        data: {"taskId": taskId}, 
      );

      print(
        ' approveTask Response: ${response.statusCode} - ${response.data}',
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('Error approving task: $e');
      rethrow;
    }
  }

  Future<bool> rejectTask(String taskId) async {
    const String uri = '/user/parent/reject_task';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.post(uri: uri, data: {"taskId": taskId});

      print(' rejectTask Response: ${response.statusCode} - ${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('Error rejecting task: $e');
      rethrow;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    final String uri = '/user/parent/deleteTask/$taskId';
    final dioClient = DioClient(hasToken: true);

    try {
      final response = await dioClient.delete(uri: uri);

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      log('Error deleting task: $e');
      rethrow;
    }
  }
}
