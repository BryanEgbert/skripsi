import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/response/list_response.dart';

void main() {
  test("Test list data", () {
    List<Map<String, dynamic>> lookup = [
      Lookup(id: 1, name: "1").toJson(),
      Lookup(id: 2, name: "2").toJson(),
    ];

    Map<String, dynamic> lookupJson = {"data": lookup};
    final listData = ListData<Lookup>.fromJson(lookupJson, Lookup.fromJson);

    expect(listData.data.length, 2);
    for (var i = 0; i < 2; i++) {
      expect(listData.data[i].toJson(), lookup[i]);
    }
  });
}
