import 'package:uuid/uuid.dart';
import '../models/todo.dart';

class TodoService {
  final List<Todo> _todos = [];
  final _uuid = Uuid();

  List<Todo> getAll() => _todos;

  Todo create(String title) {
    final todo = Todo(id: _uuid.v4(), title: title);
    _todos.add(todo);
    return todo;
  }

  Todo? update(String id, String title, bool completed) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index].title = title;
      _todos[index].completed = completed;
      return _todos[index];
    }
    return null;
  }

  // bool delete(String id) {
  //   return _todos.removeWhere((t) => t.id == id) > 0;
  // }
}
