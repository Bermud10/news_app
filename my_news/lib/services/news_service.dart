import 'package:my_news/object/news_obj.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbService {
  static const int _version = 1;
  static const String _dbName = "News.db";
  static Database? _database;

   Future<Database> _getDB() async {

    if(_database != null) {
      return _database!;
    }

    _database = await openDatabase(
        join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
          return
            await db.execute('''CREATE TABLE TableNews(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          url TEXT NOT NULL,
          urlToImage TEXT,
          publishedAt TEXT NOT NULL,
          source TEXT NOT NULL
          )''');
        },
        version: _version
    );
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
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
        "TableNews",
        where: 'title LIKE ?',
        whereArgs: ['%$query%']
    );

    return List.generate(maps.length, (i) => News.fromJson(maps[i]));
  }
}