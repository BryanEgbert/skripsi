class PaginationQueryParams {
  final int lastId;
  final int pageSize;

  PaginationQueryParams({this.lastId = 0, this.pageSize = 10});

  Map<String, String> toMap() {
    Map<String, String> map = {
      "last-id": lastId.toString(),
      "size": pageSize.toString(),
    };

    return map;
  }
}
