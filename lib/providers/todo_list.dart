import 'package:todo/model/todo_model.dart';
import 'package:todo/utils/exports.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;

  TodoListState({required this.todos});

  factory TodoListState.initial() {
    return TodoListState(todos: []);
  }

  @override
  List<Object> get props => [todos];

  @override
  bool get stringify => true;

  TodoListState copyWith({List<Todo>? todos}) {
    return TodoListState(todos: todos ?? this.todos);
  }
}

class TodoList with ChangeNotifier {
  TodoListState _state = TodoListState.initial();
  TodoListState get state => _state;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Todo>> getTodosStream() {
    return _firestore.collection('todos').snapshots().map((snapshot) {
      List<Todo> todos =
          snapshot.docs.map((doc) {
            var data = doc.data();
            return Todo(
              id: doc.id,
              desc: data['desc'],
              completed: data['completed'] ?? false,
              ownerId: data['ownerId'],
              ownerName: data['ownerName'],
              lastEditedById: data['lastEditedById'],
              lastEditedByName: data['lastEditedByName'],
            );
          }).toList();

      _state = _state.copyWith(todos: todos);
      notifyListeners();
      return todos;
    });
  }

  Future<void> addTodo(
    String todoDesc,
    String ownerId,
    String ownerName,
  ) async {
    final newTodo = Todo(
      desc: todoDesc,
      ownerId: ownerId,
      ownerName: ownerName,
    );
    try {
      DocumentReference docRef = await _firestore.collection('todos').add({
        'desc': newTodo.desc,
        'completed': newTodo.completed,
        'ownerId': newTodo.ownerId,
        'ownerName': newTodo.ownerName,
        'lastEditedById': newTodo.lastEditedById ?? '',
        'lastEditedByName': newTodo.lastEditedByName ?? '',
      });

      final addedTodo = newTodo.copyWith(id: docRef.id);
      _state = _state.copyWith(todos: [..._state.todos, addedTodo]);
      notifyListeners();
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> editTodo(
    String id,
    String todoDesc,
    String? lastEditedById,
    String? lastEditedByName,
  ) async {
    try {
      final docRef = _firestore.collection('todos').doc(id);
      await docRef.update({
        'desc': todoDesc,
        'lastEditedById': lastEditedById,
        'lastEditedByName': lastEditedByName,
      });

      final newTodos =
          _state.todos.map((Todo todo) {
            if (todo.id == id) {
              return Todo(
                id: id,
                desc: todoDesc,
                completed: todo.completed,
                ownerId: todo.ownerId,
                ownerName: todo.ownerName,
                lastEditedById: lastEditedById,
                lastEditedByName: lastEditedByName,
              );
            }
            return todo;
          }).toList();

      _state = _state.copyWith(todos: newTodos);
      notifyListeners();
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  void toggleTodo(String id) {
    final newTodos =
        _state.todos.map((Todo todo) {
          if (todo.id == id) {
            return Todo(
              id: id,
              desc: todo.desc,
              completed: !todo.completed,
              ownerId: todo.ownerId,
              ownerName: todo.ownerName,
              lastEditedById: todo.lastEditedById,
              lastEditedByName: todo.lastEditedByName,
            );
          }
          return todo;
        }).toList();

    _state = _state.copyWith(todos: newTodos);
    notifyListeners();
  }

  Future<void> removeTodo(Todo todo) async {
    try {
      await _firestore.collection('todos').doc(todo.id).delete();
      final newTodos = _state.todos.where((Todo t) => t.id != todo.id).toList();
      _state = _state.copyWith(todos: newTodos);
      notifyListeners();
    } catch (e) {
      print('Error removing todo: $e');
    }
  }
}
