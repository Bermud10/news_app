// import 'package:fbdb/fbdb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_news/object/news_obj.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreateNewsPage extends StatefulWidget {

  const CreateNewsPage({Key? key}) : super(key: key);

  @override
  CreateNewsPageState createState() => CreateNewsPageState();
}

class CreateNewsPageState extends State<CreateNewsPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController imgController = TextEditingController();
  TextEditingController publishedAtController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  late DateTime selectTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Страница создания новости"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                label: Text("Заголовок новости"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  label: Text("Описание новости"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                label: Text("Ссылка для перехода на новость"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: imgController,
              decoration: InputDecoration(
                label: Text("Ссылка для картинки новости"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: publishedAtController,
              onTap: () {
                selectDate(context);
              },
              decoration: InputDecoration(
                label: Text("Время публикации новости"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                ),

              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: sourceController,
              decoration: InputDecoration(
                  label:  Text("Источник новости"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                  )
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                  onPressed: () => {
                    getTextFromField()
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                      "Сохранить данные"
                  )),
            )
          ],

        ),
      ),
    );
  }

  getTextFromField() {

    String title = titleController.text;
    String description = descriptionController.text;
    String url = urlController.text;
    String? urlToImage = imgController.text;
    String publishedAt = publishedAtController.text;
    String source = sourceController.text;

    News newNews = News(
        title: titleController.text,
        description: descriptionController.text,
        url: urlController.text,
        urlToImage: imgController.text,
        publishedAt: selectTime,
        source: sourceController.text
    );
    
    print("!!!! ${newNews.publishedAt}");

  }

  Future<void> selectDate(BuildContext context) async {

    DateTime? time = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      cancelText: 'Отмена',
      confirmText: 'Выбрать',
      helpText: 'Выберете дату',
    );

    if (time != null){
      setState(() {
        selectTime = time;
        publishedAtController.text = DateFormat('yyyy-MM-dd').format(time);
      });
    }
  }

}




