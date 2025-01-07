import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:provider/provider.dart';

import '../../../../shared/services/snackbar/snackbar_service.dart';
import '../../domain/models/task_model.dart';
import '../viewmodels/task_list_viewmodel.dart';
import '../widgets/create_or_edit_task_bottom_sheet.dart';
import '../widgets/task_card.dart';
import '../widgets/task_list_app_bar.dart';
import '../widgets/task_list_header.dart';
import '../widgets/task_skeleton_card.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage._({
    super.key,
    required this.onlyTodo,
    required this.onlyFinished,
  });

  factory TaskListPage.todo() {
    return TaskListPage._(
      key: Key('task_list_page_todo'),
      onlyTodo: true,
      onlyFinished: false,
    );
  }

  factory TaskListPage.done() {
    return TaskListPage._(
      key: Key('task_list_page_done'),
      onlyTodo: false,
      onlyFinished: true,
    );
  }

  factory TaskListPage.search() {
    return TaskListPage._(
      key: Key('task_list_page_search'),
      onlyTodo: false,
      onlyFinished: false,
    );
  }

  final bool onlyTodo;
  final bool onlyFinished;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late final TaskListViewModel viewModel;

  final searchDebouncer = Debouncer();

  Future<void> createNewTask() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CreateOrEditTaskBottomSheet(
          viewModel: viewModel,
        );
      },
    );

    if (!mounted) return;

    if (result is TaskModel) {
      SnackbarService.showSuccess(
        context,
        message: 'Task created successfully.',
      );
    }
  }

  Future<void> editTask(TaskModel task) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CreateOrEditTaskBottomSheet(
          viewModel: viewModel,
          task: task,
        );
      },
    );

    if (!mounted) return;

    if (result is TaskModel) {
      SnackbarService.showSuccess(
        context,
        message: 'Task updated successfully.',
      );
    }
  }

  Future<void> fetchMoreTasks() async {
    if (viewModel.loading || viewModel.loadingMore) {
      return;
    }

    debugPrint('Fetching more tasks...');

    return viewModel.fetchTasks();
  }

  Future<void> refetchTasks() async {
    if (viewModel.loading || viewModel.loadingMore) {
      return;
    }

    debugPrint('Refetching tasks...');

    return viewModel.refetchTasks();
  }

  @override
  void initState() {
    super.initState();

    viewModel = context.read<TaskListViewModel>();

    viewModel.onlyTodo = widget.onlyTodo;
    viewModel.onlyFinished = widget.onlyFinished;
    viewModel.searchMode = !widget.onlyTodo && !widget.onlyFinished;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.refetchTasks();
    });
  }

  @override
  void dispose() {
    super.dispose();

    searchDebouncer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          key: widget.key,
          appBar: TaskListAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Padding(
                padding: const EdgeInsets.all(20).copyWith(bottom: 0),
                child: TaskListHeader(
                  taskCount: viewModel.totalTasks,
                  onlyFinished: viewModel.onlyFinished,
                  searchMode: viewModel.searchMode,
                  onSearch: (value) {
                    if (value == viewModel.searchFilter.filterText) return;
                    if (value.isEmpty &&
                        viewModel.searchFilter.filterText.isNotEmpty) {
                      viewModel.setFilterText('');

                      return;
                    }

                    searchDebouncer.debounce(
                      duration: Duration(milliseconds: 300),
                      onDebounce: () {
                        viewModel.setFilterText(value);
                      },
                    );
                  },
                  onDeleteAll: () async {
                    final response = await viewModel.deleteAllFinished();

                    if (!context.mounted) return;

                    if (response.isError()) {
                      final error = response.exceptionOrNull();

                      SnackbarService.showError(context,
                          message: error.toString());
                      return;
                    }

                    SnackbarService.showSuccess(
                      context,
                      message: 'All finished tasks deleted successfully.',
                    );
                  },
                ),
              ),
              if (viewModel.loading)
                Expanded(
                  child: ListView.separated(
                    itemCount: 5,
                    padding: const EdgeInsets.all(20).copyWith(
                      top: 0,
                      bottom: 20 + MediaQuery.paddingOf(context).bottom,
                    ),
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return TaskSkeletonCard();
                    },
                  ),
                )
              else if (viewModel.error != null)
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 12,
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 32,
                            ),
                            Text(
                              viewModel.error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else if (viewModel.tasks.isEmpty)
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [
                            if (viewModel.searchMode) ...[
                              Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.blueGrey.shade300,
                                size: 64,
                              ),
                              Text(
                                'No result found.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey.shade300,
                                ),
                              ),
                            ] else ...[
                              Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.blueGrey.shade300,
                                size: 64,
                              ),
                              Text(
                                'You have no task listed.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey.shade300,
                                ),
                              ),
                              SizedBox(height: 8),
                              FilledButton.tonalIcon(
                                onPressed: createNewTask,
                                label: Text(
                                  'Create task',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                icon: Icon(Icons.add),
                                style: ButtonStyle(
                                  iconSize: WidgetStateProperty.all(24),
                                  fixedSize: WidgetStateProperty.all(
                                    Size.fromHeight(50),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                    Theme.of(context)
                                        .primaryColor
                                        .withAlpha(20),
                                  ),
                                  foregroundColor: WidgetStateProperty.all(
                                    Theme.of(context).primaryColor,
                                  ),
                                  iconColor: WidgetStateProperty.all(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.extentAfter == 0) {
                        fetchMoreTasks();
                      }

                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: refetchTasks,
                      child: ListView.separated(
                        itemCount: viewModel.tasks.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 20),
                        padding: const EdgeInsets.all(20).copyWith(
                          top: 0,
                          bottom: 20 + MediaQuery.paddingOf(context).bottom,
                        ),
                        itemBuilder: (context, index) {
                          final task = viewModel.tasks[index];

                          return TaskCard(
                            title: task.title,
                            description: task.description,
                            finished: task.finished,
                            deleteMode: widget.onlyFinished,
                            onDelete: () async {
                              final result = await viewModel.deleteTask(task);

                              if (!context.mounted) return;

                              if (result.isError()) {
                                final error = result.exceptionOrNull();

                                SnackbarService.showError(
                                  context,
                                  message: error.toString(),
                                );
                                return;
                              }

                              SnackbarService.showSuccess(
                                context,
                                message: 'Task deleted successfully.',
                              );
                            },
                            onFinishedChanged: (value) async {
                              final result = await viewModel.finishTask(task);

                              if (!context.mounted) return;

                              if (result.isError()) {
                                final error = result.exceptionOrNull();

                                SnackbarService.showError(
                                  context,
                                  message: error.toString(),
                                );
                                return;
                              }

                              SnackbarService.showSuccess(
                                context,
                                message:
                                    'Task ${task.finished ? 'unfinished' : 'finished'} successfully.',
                              );
                            },
                            onEdit: () => editTask(task),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
