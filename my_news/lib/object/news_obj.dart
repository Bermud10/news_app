import 'package:hive/hive.dart';

part 'news_obj.g.dart';

@HiveType(typeId: 0)
class News {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String? urlToImage;

  @HiveField(4)
  final DateTime publishedAt;

  @HiveField(5)
  final String source;

  News({
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.source,
  });

// коммент мой, не нейросетевой, чтоб не забыть!
// команда для генерации news_obg.g flutter pub run build_runner build

}