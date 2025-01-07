import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'modules/tasks/data/repositories/task_hive_repository_impl.dart';
import 'modules/tasks/ui/viewmodels/task_list_viewmodel.dart';
import 'shared/router/route_config.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskListViewModel>(
      create: (_) => TaskListViewModel(
        taskRepository: TaskHiveRepositoryImpl(
          hive: Hive,
        ),
      ),
      child: MaterialApp.router(
        key: key,
        title: 'Taski',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blueAccent.shade700,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent.shade700,
            primary: Colors.blueAccent.shade700,
          ),
        ),
        routerConfig: RouteConfig.config,
      ),
    );
  }
}
