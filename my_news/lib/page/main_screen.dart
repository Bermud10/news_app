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

  DbService dbService = DbService();

  final TextEditingController _searchController = TextEditingController();
  StreamSubscription<List<News>>? subscription;
  bool _isLoading = false;
  List<News> foundNews = [];

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
                  onPressed: getNewsFromBD,
                ),
              ),
              // onSubmitted: (_) => searchNewsFromBd(),
            ),

            const SizedBox(height: 16),

            // Кнопка поиска
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: getNewsFromBD,
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
               itemCount: foundNews.length,
               itemBuilder: (context, i) {

                 if (_isLoading) {
                   return CircularProgressIndicator();
                 }

                 if(_searchController.text.isNotEmpty && foundNews.isEmpty){
                   return Center(
                     child: Text(
                       "Новостей не найдено"
                     ),
                   );
                 }

                 return NewsItem(news: foundNews[i]);
               }
             ),
           )

          ],
        ),
      ),
    );
  }

  Future<void> getNewsFromBD() async {

    subscription?.cancel();

   setState(() {
     _isLoading = true;
     foundNews = [];
   });
   print("!!!!!!");
   final stream = dbService.searchNews(_searchController.text.trim());
   subscription = stream.listen((value) {
     setState(() {
       print("!!!!!!${value}");
       foundNews = value;
       _isLoading = false;
     });
   },onError: (error) {
     setState(() {
       _isLoading = false;
       foundNews = [];
     });
   }
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