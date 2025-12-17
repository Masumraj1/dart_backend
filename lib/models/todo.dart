// class Todo {
//   String id;
//   String title;
//   bool completed;
//
//   Todo({required this.id, required this.title, this.completed = false});
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'title': title,
//     'completed': completed,
//   };
//
//   factory Todo.fromMap(Map<String, dynamic> map) => Todo(
//     id: map['id'],
//     title: map['title'],
//     completed: map['completed'] == true || map['completed'] == 'true',
//   );
// }
