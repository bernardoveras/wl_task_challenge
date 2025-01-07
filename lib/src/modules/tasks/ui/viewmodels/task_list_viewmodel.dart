import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/mixins/error_mixin.dart';
import '../../../../shared/mixins/loading_mixin.dart';
import '../../../../shared/mixins/search_mixin.dart';
import '../../domain/models/search_task_filter_model.dart';
import '../../domain/models/task_model.dart';
import '../../domain/repositories/i_task_repository.dart';

class TaskListViewModel extends ChangeNotifier
    with SearchMixin<SearchTaskFilterModel>, LoadingMixin, ErrorMixin {
  final ITaskRepository taskRepository;

  TaskListViewModel({
    required this.taskRepository,
  }) {
    searchFilter = SearchTaskFilterModel();
  }

  bool searchMode = false;
  bool onlyTodo = false;
  bool onlyFinished = false;

  @override
  void setFilterText(String value) {
    super.setFilterText(value);
    refetchTasks();
  }

  List<TaskModel> tasks = [];
  int totalTasks = 0;

  Future<void> fetchTasks() async {
    try {
      if (searchFilter.pageNumber == 1) {
        setLoading(true);
      } else {
        setLoadingMore(true);
      }

      setError(null);

      if (onlyTodo) {
        searchFilter = searchFilter.copyWith(
          onlyTodo: true,
          onlyFinished: false,
        );
      } else if (onlyFinished) {
        searchFilter = searchFilter.copyWith(
          onlyTodo: false,
          onlyFinished: true,
        );
      } else {
        searchFilter = searchFilter.copyWith(
          onlyTodo: false,
          onlyFinished: false,
        );
      }

      final response = await taskRepository.fetch(
        filter: searchFilter,
      );

      if (response.isError()) {
        setError(response.exceptionOrNull().toString());
        return;
      }

      final newTasks = response.getOrThrow();

      tasks = [
        ...tasks,
        ...newTasks.data,
      ];

      totalTasks = newTasks.total;

      if (tasks.isNotEmpty) {
        nextPage();
      }

      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
      setLoadingMore(false);
    }
  }

  Future<void> refetchTasks() {
    setPageNumber(1);
    tasks = [];

    return fetchTasks();
  }

  AsyncResult<TaskModel> insertTask(TaskModel task) async {
    final response = await taskRepository.insert(task);

    if (response.isError()) {
      return response;
    }

    tasks.insert(0, task);

    totalTasks++;

    notifyListeners();

    return response;
  }

  AsyncResult<bool> deleteTask(TaskModel task) async {
    final response = await taskRepository.delete(task.id);

    if (response.isError()) {
      return response;
    }

    tasks.remove(task);

    totalTasks--;

    notifyListeners();

    return response;
  }

  AsyncResult<TaskModel> updateTask(TaskModel task) async {
    final response = await taskRepository.update(task);

    if (response.isError()) {
      return response;
    }

    final index = tasks.indexWhere((x) => x.id == task.id);

    tasks[index] = task;

    if ((onlyTodo && task.finished) || (onlyFinished && !task.finished)) {
      tasks.removeAt(index);
      totalTasks--;
    }

    notifyListeners();

    return response;
  }

  AsyncResult<TaskModel> finishTask(TaskModel task) async {
    final updatedTask = task.copyWith(finished: !task.finished);

    final response = await updateTask(updatedTask);

    return response;
  }

  AsyncResult<bool> deleteAllFinished() async {
    final finishedTasks =
        tasks.where((x) => x.finished).map((x) => x.id).toList();

    final response = await taskRepository.deleteArray(finishedTasks);

    if (response.isError()) {
      return response;
    }

    tasks.removeWhere((x) => finishedTasks.contains(x.id));

    notifyListeners();

    return response;
  }
}
