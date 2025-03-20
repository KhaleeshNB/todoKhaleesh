import 'package:todo/model/todo_model.dart';
import 'package:todo/utils/exports.dart';

class FilteredTodosState extends Equatable {
  final List<Todo> filteredTodos;
  FilteredTodosState({required this.filteredTodos});

  factory FilteredTodosState.initial() {
    return FilteredTodosState(filteredTodos: []);
  }

  FilteredTodosState copyWith({List<Todo>? filteredTodos}) {
    return FilteredTodosState(
      filteredTodos: filteredTodos ?? this.filteredTodos,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [filteredTodos];
}

class FilteredTodos with ChangeNotifier {
  // FilteredTodosState _state = FilteredTodosState.initial();
  late FilteredTodosState _state;
  final List<Todo> initialFilteredTodos;

  FilteredTodos({required this.initialFilteredTodos}) {
    print('initial filtered todos: ${initialFilteredTodos}');
    _state = FilteredTodosState(filteredTodos: initialFilteredTodos);
  }
  FilteredTodosState get state => _state;

  void update(TodoFilter todoFilter, TodoSearch todoSearch, TodoList todoList) {
    List<Todo> _filteredTodos;
    switch (todoFilter.state.filter) {
      case FilterTodo.active:
        _filteredTodos =
            todoList.state.todos.where((Todo todo) => !todo.completed).toList();
        break;

      case FilterTodo.completed:
        _filteredTodos =
            todoList.state.todos.where((Todo todo) => todo.completed).toList();
        break;

      case FilterTodo.all:
        _filteredTodos = todoList.state.todos;
        break;
    }
    if (todoSearch.state.searchTerm.isNotEmpty) {
      _filteredTodos =
          _filteredTodos
              .where(
                (Todo todo) => todo.desc.toLowerCase().contains(
                  todoSearch.state.searchTerm,
                ),
              )
              .toList();
    }
    _state = _state.copyWith(filteredTodos: _filteredTodos);
    notifyListeners();
  }
}
