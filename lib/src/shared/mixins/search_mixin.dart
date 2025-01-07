import '../models/search_filter_model.dart';

mixin SearchMixin<TSearchModel extends SearchFilterModel> {
  late TSearchModel searchFilter;

  void setFilterText(String value) {
    searchFilter = searchFilter.copyWith(filterText: value) as TSearchModel;
  }

  void setPageSize(int value) {
    searchFilter = searchFilter.copyWith(pageSize: value) as TSearchModel;
  }

  void setPageNumber(int value) {
    searchFilter = searchFilter.copyWith(pageNumber: value) as TSearchModel;
  }

  void nextPage() {
    searchFilter = searchFilter.copyWith(
      pageNumber: searchFilter.pageNumber + 1,
    ) as TSearchModel;
  }
}
