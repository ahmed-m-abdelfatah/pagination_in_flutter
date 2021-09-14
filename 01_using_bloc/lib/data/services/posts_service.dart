import 'dart:convert';

import 'package:http/http.dart' as http;

class PostsService {
  static const int FETCH_LIMIT = 15;
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<dynamic>> fetchPosts(int page) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl + '?_limit=$FETCH_LIMIT&_page=$page'),
      );
      return jsonDecode(response.body) as List<dynamic>;
    } catch (error) {
      return [];
    }
  }
}
