import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../object/news_obj.dart';

class NewsService {
  static const String _apiKey = '601a175c50f34e899a91fa10d12750c5';
  static const String _baseUrl = 'https://newsapi.org/v2';

  Stream<List<News>> searchNews(String query) async* {

    try {
      final request = http.Request('GET', Uri.parse(
          '$_baseUrl/everything?q=$query&sortBy=publishedAt&pageSize=25&apiKey=$_apiKey'));

      final response = await http.Client().send(request);

      String respData = await response.stream.bytesToString();

      Map<String, dynamic> jsonResp = jsonDecode(respData);

      final List<News> body = (jsonResp["articles"])
          .map<News>((obj) => News.fromJson(obj))
          .toList();

      yield body;
    } catch (e) {
      print("Ошибка при запросе на получение новостей");
      yield [];
    }

  }
}