import 'package:my_news/object/news_obj.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbService {
  static const int _version = 1;
  static const String _dbName = "News.db";
  static Database? _database;

   Future<Database> _getDB() async {
     print("*********1");
    if(_database != null) {
      print("*********2");
      return _database!;
    }
     print("*********3");

     final dbPath = await getDatabasesPath();
     final path = join(dbPath, _dbName);

    try {
      _database = await openDatabase(
          path,
          onCreate: (db, version) async {
            await db.execute('''CREATE TABLE TableNews(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          url TEXT NOT NULL,
          urlToImage TEXT,
          publishedAt TEXT NOT NULL,
          source TEXT NOT NULL
          )''');
            print("**** Таблица создана");
          },
          version: _version
      );
      print("**** бд открыта");
    }catch (e) {
      print("*********4 ошибка создания бд${e}");
    }
    return _database!;
  }

  Future<int> addNews(News news) async {
    final db = await _getDB();
    return await db.insert("TableNews", news.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<News>> getAllNews() async {
    final db = await _getDB();
    final List<Map<String,dynamic>> maps = await db.query('TableNews');

    if(maps.isEmpty){
      return [];
    }
    return List.generate(maps.length, (i) => News.fromJson(maps[i]));
  }

  Stream<List<News>> searchNews(String query){
    return Stream.fromFuture(_searchNewsFuture(query));
  }

  Future<List<News>> _searchNewsFuture(String query) async {
     print("!!!!!!1");
    final db = await _getDB();
     print("!!!!!!2");
    final List<Map<String, dynamic>> maps = await db.query(
        "TableNews",
        where: 'title LIKE ?',
        whereArgs: ['%$query%']
    );
     print("!!!!!!3");
    return List.generate(maps.length, (i) => News.fromJson(maps[i]));
  }
}