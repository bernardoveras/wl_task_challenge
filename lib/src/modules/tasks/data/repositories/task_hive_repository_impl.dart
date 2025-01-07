import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/models/paginated_result_model.dart';
import '../../domain/models/search_task_filter_model.dart';
import '../../domain/models/task_model.dart';
import '../../domain/repositories/i_task_repository.dart';

class TaskHiveRepositoryImpl implements ITaskRepository {
  final HiveInterface hive;

  TaskHiveRepositoryImpl({
    required this.hive,
  });

  final String _boxName = "tasks";

  Future<Box> get _box async => await hive.openBox(_boxName);

  Future<List<TaskModel>> _fetchAllTasksOnHive() async {
    final box = await _box;

    final resultJson = box.get('tasks', defaultValue: '[]') as String;

    final result = jsonDecode(resultJson) as List;

    var tasks = result.map((e) => TaskModel.fromJson(e)).toList();

    return tasks;
  }

  @override
  AsyncResult<PaginatedResultModel<TaskModel>> fetch({
    SearchTaskFilterModel filter = const SearchTaskFilterModel(),
  }) async {
    try {
      var tasks = await _fetchAllTasksOnHive();

      if (filter.onlyTodo) {
        tasks = tasks.where((task) => !task.finished).toList();
      } else if (filter.onlyFinished) {
        tasks = tasks.where((task) => task.finished).toList();
      }

      if (filter.filterText.isNotEmpty) {
        tasks = tasks
            .where((task) => task.title
                .toLowerCase()
                .contains(filter.filterText.toLowerCase()))
            .toList();
      }

      final total = tasks.length;

      tasks = tasks.skip(filter.skip).take(filter.pageSize).toList();

      return Success(
        PaginatedResultModel(
          total: total,
          pageNumber: filter.pageNumber,
          pageSize: filter.pageSize,
          data: tasks,
        ),
      );
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  AsyncResult<TaskModel> insert(TaskModel task) async {
    try {
      var tasks = await _fetchAllTasksOnHive();

      tasks.insert(0, task);

      final box = await _box;

      final encoded = jsonEncode(tasks.map((e) => e.toJson()).toList());

      await box.put('tasks', encoded);

      return Success(task);
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  AsyncResult<TaskModel> update(TaskModel task) async {
    try {
      var tasks = await _fetchAllTasksOnHive();

      final index = tasks.indexWhere((x) => x.id == task.id);

      if (index == -1) {
        return Failure(Exception('Task not found.'));
      }

      tasks[index] = task;

      final box = await _box;

      final encoded = jsonEncode(tasks.map((e) => e.toJson()).toList());

      await box.put('tasks', encoded);

      return Success(task);
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  AsyncResult<bool> delete(String id) async {
    try {
      var tasks = await _fetchAllTasksOnHive();

      tasks.removeWhere((x) => x.id == id);

      final box = await _box;

      final encoded = jsonEncode(tasks.map((e) => e.toJson()).toList());

      await box.put('tasks', encoded);

      return Success(true);
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  AsyncResult<bool> deleteArray(List<String> ids) async {
    try {
      var tasks = await _fetchAllTasksOnHive();

      tasks.removeWhere((x) => ids.contains(x.id));

      final box = await _box;

      final encoded = jsonEncode(tasks.map((e) => e.toJson()).toList());

      await box.put('tasks', encoded);

      return Success(true);
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e));
    }
  }
}
