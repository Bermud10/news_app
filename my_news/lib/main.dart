import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_news/page/create_news_page.dart';
import 'package:my_news/page/main_screen.dart';
import 'package:go_router/go_router.dart';

import 'object/news_obj.dart';

main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NewsAdapter());
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Новости",
      routerConfig: _router,
      debugShowCheckedModeBanner: false,

    );
  }

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => NewsScreen(),
      ),

      GoRoute(
        path: '/create_news',
        builder: (context, state) =>  CreateNewsPage(),
      )
    ]
  );
}