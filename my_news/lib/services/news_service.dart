import 'package:hive/hive.dart';
import '../object/news_obj.dart';

class HiveDbService {
  static const String _boxName = 'news_box';

  Future<Box<News>> _openBox() async {
    return await Hive.openBox<News>(_boxName);
  }

  Future<void> addNews(News news) async {
    final box = await _openBox();
    await box.add(news);
  }

  Future<List<News>> getAllNews() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<List<News>> searchNews(String query) async {
    if (query.trim().isEmpty) return [];

    final box = await _openBox();
    final lowerQuery = query.toLowerCase();

    return box.values
        .where((news) =>
    news.title.toLowerCase().contains(lowerQuery) ||
        news.description.toLowerCase().contains(lowerQuery))
        .toList();
  }
}