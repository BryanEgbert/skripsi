abstract class JsonObject<T> {
  T fromJson();
}

class ListData<T> {
  final List<T> data;

  ListData({required this.data});

  factory ListData.fromJson(Map<String, dynamic> json, Function fromJson) {
    final items = json["data"].cast<Map<String, dynamic>>();
    return ListData<T>(
      data: List<T>.from(
        items.map(
          (item) => fromJson(item),
        ),
      ),
    );
  }
}
