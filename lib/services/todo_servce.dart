import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
  static var basePath = 'http://api.nstack.in/v1/todos';

  static Future<bool> deleteById(String id) async {
    final url = '${TodoService.basePath}/$id';
    final uri = Uri.parse(url);
    print(uri);
    final response = await http.delete(uri);

    return response.statusCode == 200;
  }

  static Future<List?> fetchTodo() async {
    final url = '${TodoService.basePath}?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;

      return result;
    }
    return null;
  }

  static Future<bool> submitData(body) async {
    final url = TodoService.basePath;
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode == 201;
  }

  static Future<bool> updateData(String id, body) async {
    final url = '${TodoService.basePath}/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode == 200;
  }
}
