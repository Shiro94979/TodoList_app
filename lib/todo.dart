class Todo {
  String title;
  bool complete;

  Todo({
    required this.title,
    this.complete = false,
  });
  Todo.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        complete = map['complete'];

  updateTitle(title) {
    this.title = title;
  }

  Map toMap() {
    return {
      'title': title,
      'complete': complete,
    };
  }
}
