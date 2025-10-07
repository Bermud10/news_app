import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';
import '../widgets/news_item.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  final TextEditingController _searchController = TextEditingController();
  List<News> _news = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchNews() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final articles = await _newsService.searchNews(_searchController.text);
      setState(() {
        _news = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка при загрузке новостей';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Приложение новостей'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поисковая строка
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Введите тему для поиска...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchNews,
                ),
              ),
              onSubmitted: (_) => _searchNews(),
            ),

            const SizedBox(height: 16),

            // Кнопка поиска
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _searchNews,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'Поиск',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Результаты поиска
            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {

    TextStyle style = TextStyle(fontSize: 16, color: Colors.black);
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(fontSize: 20, color: Colors.red),
        ),
      );
    }

    if (_news.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Text(
          'Новостей не найдено',
          style: style
        ),
      );
    }

    if (_news.isEmpty) {
      return Center(
        child: Text(
          'Введите запрос для поиска новостей',
          style: style
        ),
      );
    }

    return ListView.builder(
      itemCount: _news.length,
      itemBuilder: (context, index) {
        return NewsItem(news: _news[index]);
      },
    );
  }

  //отписка
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}