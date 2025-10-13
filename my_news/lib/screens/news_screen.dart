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
        print("!!!!!! ${listNews}");

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

            const SizedBox(height: 24),

           Expanded(
             child: ListView.builder(
               itemCount: listNews.length,
               itemBuilder: (context, i) {
                 return NewsItem(news: listNews[i]);
               }
             ),
           )

            // Expanded(
            //   child: StreamBuilder<List<News>>(
            //       stream: newsStream,
            //       builder: (context, snapshot) {
            //
            //         if (_isLoading && !snapshot.hasData) {
            //           return Center(child: CircularProgressIndicator());
            //         }
            //
            //         if (_searchController.text.isNotEmpty && snapshot.data!.isEmpty) {
            //           return Center(
            //             child: Text('Новостей не найдено'),
            //           );
            //         }
            //
            //         if (snapshot.hasError) {
            //           return Center(
            //             child: Text('Ошибка: ${snapshot.error}'),
            //           );
            //         }
            //
            //         if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //           return const Center(
            //             child: Text('Введите запрос для поиска новостей'),
            //           );
            //         }
            //
            //         final news = snapshot.data!;
            //
            //         return ListView.builder(
            //           itemCount: news.length,
            //           itemBuilder: (context, i) {
            //             return NewsItem(news: news[i]);
            //           }
            //         );
            //       }
            //   )
            // ),
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