class SearchFilterModel {
  final String filterText;
  final int pageSize;
  final int pageNumber;

  int get skip => pageSize * (pageNumber - 1);
  const SearchFilterModel({
    String? filterText,
    int? pageSize,
    int? pageNumber,
  })  : filterText = filterText ?? '',
        pageSize = pageSize ?? 10,
        pageNumber = pageNumber ?? 1;

  SearchFilterModel copyWith({
    String? filterText,
    int? pageSize,
    int? pageNumber,
  }) {
    return SearchFilterModel(
      filterText: filterText ?? this.filterText,
      pageSize: pageSize ?? this.pageSize,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }
}
