import 'package:flutter/material.dart';
import 'todo.dart';

class TodoView extends StatefulWidget {
  final Todo item;
  TodoView({ required this.item });

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  late TextEditingController titleController;


  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController(
      text: widget.item.title
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.title != '' ? 'Edit todo' : 'New todo',
          key: Key('new-item-title'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: titleController,
              autofocus: true,
              onEditingComplete: submit,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 14.0,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
                overlayColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).backgroundColor,
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Color.fromARGB(255, 197, 96, 96),
                ),
              ),
              onPressed: submit,
            ),
          ],
        ),
      ),
    );
  }

  void submit(){
    if(titleController.text != '')
      Navigator.of(context).pop(titleController.text);
  }
}