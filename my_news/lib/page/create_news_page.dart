import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_news/object/news_obj.dart';
import '../services/news_service.dart';

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
  late DateTime selectTime = DateTime.now();
  String warningMess = "Заполните обязательные поля:\n -Заголовок\n -Описание\n -Ссылка на новость\n -Источник новости";

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
                  onPressed: getTextFromField,
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
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                  onPressed: () => {
                    context.go("/")
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
                      "Страница поиска"
                  )),
            )
          ],

        ),
      ),
    );
  }

  getTextFromField() async {

    if(
    titleController.text.isEmpty ||
    descriptionController.text.isEmpty ||
    urlController.text.isEmpty ||
    sourceController.text.isEmpty
    ){
      showModalDialog(context, warningMess);
      return;
    }

    News newNews = News(
        title: titleController.text,
        description: descriptionController.text,
        url: urlController.text,
        urlToImage: imgController.text,
        publishedAt: selectTime,
        source: sourceController.text
    );

    try {
      DbService.addNews(newNews);

      showModalDialog(context, "Новость добавлена");

      setState(() {
        clearControls();
      });

    }catch (e) {
      showModalDialog(context, "Ошибка при добавлении новости");
    }

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

  clearControls(){
    titleController.clear();
    descriptionController.clear();
    urlController.clear();
    imgController.clear();
    publishedAtController.clear();
    sourceController.clear();
  }

  showModalDialog(BuildContext _context, String text){
    return showDialog(
        context: _context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: context.pop,
                  child: Text("Ок")
              )
            ],
          );
        }
    );
  }

}




