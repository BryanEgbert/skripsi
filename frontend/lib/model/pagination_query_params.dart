class CursorBasedPaginationQueryParams {
  final int lastId;
  final int pageSize;

  CursorBasedPaginationQueryParams({this.lastId = 0, this.pageSize = 10});

  Map<String, String> toMap() {
    Map<String, String> map = {
      "last-id": lastId.toString(),
      "size": pageSize.toString(),
    };

    return map;
  }
}

class OffsetPaginationQueryParams {
  final int page;
  final int pageSize;

  OffsetPaginationQueryParams({this.page = 1, this.pageSize = 10});

  Map<String, String> toMap() {
    Map<String, String> map = {
      "page": page.toString(),
      "size": pageSize.toString(),
    };

    return map;
  }
}
