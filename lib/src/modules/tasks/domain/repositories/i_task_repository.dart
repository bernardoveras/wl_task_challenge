import 'package:result_dart/result_dart.dart';

import '../../../../shared/models/paginated_result_model.dart';
import '../models/search_task_filter_model.dart';
import '../models/task_model.dart';

abstract interface class ITaskRepository {
  AsyncResult<PaginatedResultModel<TaskModel>> fetch({
    SearchTaskFilterModel filter = const SearchTaskFilterModel(),
  });
  AsyncResult<TaskModel> insert(TaskModel task);
  AsyncResult<TaskModel> update(TaskModel task);
  AsyncResult<bool> delete(String id);
  AsyncResult<bool> deleteArray(List<String> ids);
}
