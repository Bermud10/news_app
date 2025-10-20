import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../object/news_obj.dart';
import '../services/news_service.dart';
import '../widgets/news_item.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {


  final TextEditingController _searchController = TextEditingController();
  late StreamSubscription? subscription;
  bool _isLoading = false;

  late List<News> findNews;


  searchNewsFromBd() async {
    findNews = [];

    List<News>? allNews = await DbService.getAllNews();

    if(allNews == null){
      return;
    }


    for(News news in allNews){
      if(news.title.contains(_searchController.text)){
        findNews.add(news);
      }
    }

    findNews.sort((a,b) => a.publishedAt.compareTo(b.publishedAt));

    return findNews;
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
                  onPressed: searchNewsFromBd,
                ),
              ),
              onSubmitted: (_) => searchNewsFromBd(),
            ),

            const SizedBox(height: 16),

            // Кнопка поиска
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: searchNewsFromBd,
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
                onPressed: () => context.go("/create_news"),
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
               // itemCount: searchNewsFromBd().length,
               itemBuilder: (context, i) {

                 if (_isLoading) {
                   return CircularProgressIndicator();
                 }

                 if(_searchController.text.isNotEmpty && searchNewsFromBd().isEmpty){
                   return Center(
                     child: Text(
                       "Новостей не найдено"
                     ),
                   );
                 }

                 return NewsItem(news: searchNewsFromBd()[i]);
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