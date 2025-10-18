import 'dart:async';
import 'package:flutter/material.dart';
import '../object/news_obj.dart';
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
  late StreamSubscription? subscription;
  bool _isLoading = false;

  List<News> listNews = [];

  void _searchNews() async {

    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {

      subscription = _newsService.searchNews(_searchController.text).listen((data) {

        listNews = data;

        setState(() {
          _isLoading = false;
        });

      });
    } catch (e) {
      print("Ошибка при поиске");
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
                child: _isLoading ?
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  )

                : Text(
                  'Поиск',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, "/create_news"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Создать новость',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

          const SizedBox(height: 24),

           Expanded(
             child: ListView.builder(
               itemCount: listNews.length,
               itemBuilder: (context, i) {

                 if (_isLoading) {
                   return CircularProgressIndicator();
                 }

                 if(_searchController.text.isNotEmpty && listNews.isEmpty){
                   return Center(
                     child: Text(
                       "Новостей не найдено"
                     ),
                   );
                 }

                 return NewsItem(news: listNews[i]);
               }
             ),
           )

          ],
        ),
      ),
    );
  }

  //отписка
  @override
  void dispose() {
    subscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}