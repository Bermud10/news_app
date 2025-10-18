import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              decoration: InputDecoration(
                label: Text("Время публикации новости"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                )
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
    String img = imgController.text;
    String publishedAt = publishedAtController.text;
    String source = sourceController.text;
    print("!!!! ${title}");
  }

}




