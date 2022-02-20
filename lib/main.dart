

import 'package:flutter/material.dart';
import 'package:todolist_app/todo.dart';
import 'package:todolist_app/edit_todo.dart';
void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodolistApp',
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>with TickerProviderStateMixin {
  List<Todo> items = new List<Todo>.empty(growable: true);
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  late AnimationController emplistCon;
  
   @override
  void initState() {
    emplistCon = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 50),
    );
    emplistCon.forward();
    super.initState();
  }

  @override
  void dispose() {
    emplistCon.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TodolistApp',
          key: Key('main-app-title'),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle_outline),
        onPressed: ()=>goToNewItemView(),
      ),
      body: renderScreen(),
    );
  }

  Widget renderScreen(){
    if(items.length > 0){
      return listView();
    }
    else{
      return emptyList();
    }
  }

  Widget emptyList(){
    return Center(
    child: FadeTransition(
      opacity: emplistCon,
      child: Text('No items')
    )
    );
  }

   Widget listView() {
    return AnimatedList(
      key: animatedListKey,
      initialItemCount: items.length,
      itemBuilder: (BuildContext context,int index, animation){
        return SizeTransition(
          sizeFactor: animation,
          child: buildItem(items[index], index),
        );
      },
    );
  }

   Widget buildItem(Todo item, int index){
    return Dismissible(
      key: Key('${item.hashCode}'),
      background: Container(color: Colors.red[700]),
      onDismissed: (direction) => removeItemFromList(item, index),
      direction: DismissDirection.startToEnd,
      child: buildListTile(item, index),
    );
  }

  Widget buildListTile(item, index){
    return ListTile(
      onTap: () => changeItemCompleteness(item),
      onLongPress: () => goToEditItemView(item),
      title: Text(item.title,
        key: Key('item-$index'),
        style: TextStyle(
          color: item.complete? Colors.grey : Colors.black,
          decoration: item.complete ? TextDecoration.lineThrough : null
        ),
      ),

      trailing: Icon(item.complete
        ? Icons.check_box
        : Icons.check_box_outline_blank,
        key: Key('complete-icon-$index'),
      ),
    );
  }

  void changeItemCompleteness(Todo item){
    setState(() {
      item.complete = !item.complete;
    });
  }

  void goToNewItemView(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return TodoView(item: Todo(title: ''),);
    })).then((title){
      if(title != null) {
        setState(() {
          addItem(Todo(title: title));
        });
      }
    });
  }

  void addItem(Todo item){
    items.insert(0, item);
    if(animatedListKey.currentState != null)
      animatedListKey.currentState!.insertItem(0);
  }

  void goToEditItemView(Todo item){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return TodoView(item: item);
    })).then((title){
      if(title != null) {
        editItem(item, title);
      }
    });
  }

  void editItem(Todo item ,String title){
    item.title = title;
  }

  void removeItemFromList(Todo item, int index) {
    animatedListKey.currentState!.removeItem(index, (context, animation){
      return SizedBox(width: 0, height: 0,);
    });
    deleteItem(item);

  }

  void deleteItem(Todo item){
    items.remove(item);
    if(items.isEmpty) {
      emplistCon.reset();
      setState(() {});
      emplistCon.forward();
    }
  }
}




  

