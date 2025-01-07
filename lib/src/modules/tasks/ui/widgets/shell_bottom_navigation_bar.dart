import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../shared/router/routes.dart';
import '../../../../shared/services/snackbar/snackbar_service.dart';
import '../../domain/models/task_model.dart';
import '../viewmodels/task_list_viewmodel.dart';
import 'create_or_edit_task_bottom_sheet.dart';

enum ShellTab {
  todo(Icons.checklist_rounded, 'Todo'),
  create(Icons.add_box_outlined, 'Create'),
  search(Icons.search, 'Search'),
  done(Icons.check_box_outlined, 'Done');

  final IconData icon;
  final String label;

  const ShellTab(this.icon, this.label);
}

class ShellBottomNavigationBar extends StatefulWidget {
  const ShellBottomNavigationBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ShellBottomNavigationBar> createState() =>
      _ShellBottomNavigationBarState();
}

class _ShellBottomNavigationBarState extends State<ShellBottomNavigationBar> {
  var currentTab = ShellTab.todo;

  late final TaskListViewModel taskViewModel;

  Future<void> createNewTask() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CreateOrEditTaskBottomSheet(
          viewModel: taskViewModel,
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

  void onTabSelected(ShellTab value) {
    ScaffoldMessenger.of(context).clearSnackBars();

    switch (value) {
      case ShellTab.todo:
        context.go(Routes.todos);
      case ShellTab.done:
        context.go(Routes.dones);
      case ShellTab.search:
        context.go(Routes.search);
      case ShellTab.create:
        createNewTask();
        return;
    }

    debugPrint('Tab selected: ${value.label}');

    setState(() {
      currentTab = value;
    });
  }

  @override
  void initState() {
    super.initState();

    taskViewModel = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.blueGrey.shade50,
              width: 2,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentTab.index,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.blueGrey.shade200,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconSize: 24,
          selectedLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          onTap: (index) => onTabSelected(ShellTab.values[index]),
          items: ShellTab.values
              .map(
                (x) => BottomNavigationBarItem(
                  icon: Icon(x.icon),
                  label: x.label,
                ),
              )
              .toList(),
        ),
      ),
      body: widget.child,
    );
  }
}
