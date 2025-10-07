import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../models/news_model.dart';

class NewsItem extends StatelessWidget {
  final News news;

  const NewsItem({Key? key, required this.news}) : super(key: key);

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(news.url);
    if (!await launchUrl(url)) {
      throw Exception('Не могу открыть - $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: _launchUrl,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              if (news.urlToImage != null && news.urlToImage!.isNotEmpty) ... [
                Container(
                    width: 120,
                    height: 120,
                    child: Image.network(
                      news.urlToImage!,
                      errorBuilder: (BuildContext context, Object exception,StackTrace? stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },

                    )
                ),
                const SizedBox(width: 12),
              ],

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      news.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            news.source,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[300],
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('dd.MM.yyyy HH:mm').format(news.publishedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}