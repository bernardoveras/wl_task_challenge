import '../../../../shared/models/search_filter_model.dart';

class SearchTaskFilterModel extends SearchFilterModel {
  final bool onlyTodo;
  final bool onlyFinished;

  const SearchTaskFilterModel({
    super.filterText,
    super.pageSize,
    super.pageNumber,
    this.onlyTodo = false,
    this.onlyFinished = false,
  });

  @override
  SearchTaskFilterModel copyWith({
    String? filterText,
    int? pageSize,
    int? pageNumber,
    bool? onlyTodo,
    bool? onlyFinished,
  }) {
    return SearchTaskFilterModel(
      filterText: filterText ?? this.filterText,
      pageSize: pageSize ?? this.pageSize,
      pageNumber: pageNumber ?? this.pageNumber,
      onlyTodo: onlyTodo ?? this.onlyTodo,
      onlyFinished: onlyFinished ?? this.onlyFinished,
    );
  }
}
