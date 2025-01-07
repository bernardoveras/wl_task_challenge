class PaginatedResultModel<TData extends Object> {
  final int total;
  final int pageNumber;
  final int pageSize;
  final List<TData> data;

  PaginatedResultModel({
    required this.total,
    required this.pageNumber,
    required this.pageSize,
    required this.data,
  });
}
