import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_news/object/news_obj.dart';
import 'package:my_news/page/create_news_page.dart';
import 'package:my_news/page/main_screen.dart';
// import 'package:go_router/go_router.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<News>('news_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Новости",
      home: NewsScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/create_news': (context) => const CreateNewsPage(),
      },
    );
  }

  // final GoRouter _router = GoRouter(
  //   routes: [
  //     GoRoute(
  //       path: '/',
  //       builder: (context, state) => NewsScreen(),
  //     ),
  //
  //     GoRoute(
  //       path: '/create_news',
  //       builder: (context, state) =>  CreateNewsPage(),
  //     )
  //   ]
  // );
}