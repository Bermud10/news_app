import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../object/news_obj.dart';

class NewsService {
  static const String _apiKey = '601a175c50f34e899a91fa10d12750c5';
  static const String _baseUrl = 'https://newsapi.org/v2';

  final StreamController<List<News>> newsController = StreamController<List<News>>();

  Stream<List<News>> get newsStream => newsController.stream;

  Future<void> searchNews(String query) async {
    try {

      newsController.add([]);

      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query&sortBy=publishedAt&pageSize=25&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles  = data['articles'] as List;

        final newsArticles = articles.map((article) => News.fromJson(article)).toList();

        newsController.add(newsArticles);

      } else {
        newsController.addError('Ошибка загрузки новостей: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void dispose() {
    newsController.close();
  } // метод нужен для "освобождения ресурсов", отмены подписок, вызывается сам при полном перестроении дерева виджетов либо при закрытии страницы
}