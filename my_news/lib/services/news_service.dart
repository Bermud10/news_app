import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const String _apiKey = '601a175c50f34e899a91fa10d12750c5';
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<News>> searchNews(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query&sortBy=publishedAt&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;

        return articles.map((article) => News.fromJson(article)).toList();
      } else {
        throw Exception('ошибка загрузки новостей');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}