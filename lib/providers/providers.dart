import 'package:provider/single_child_widget.dart';
import 'package:todo/utils/exports.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<UserAuthProvider>(
    create: (context) => UserAuthProvider(),
  ),
  ChangeNotifierProvider<SignupProvider>(create: (context) => SignupProvider()),
  ChangeNotifierProvider<LoginProvider>(create: (context) => LoginProvider()),
  ChangeNotifierProvider<TodoFilter>(create: (context) => TodoFilter()),
  ChangeNotifierProvider<TodoSearch>(create: (context) => TodoSearch()),
  ChangeNotifierProvider<TodoList>(create: (context) => TodoList()),
  ChangeNotifierProxyProvider<TodoList, ActiveTodoCount>(
    create:
        (context) => ActiveTodoCount(
          initialActiveTodoCount: context.read<TodoList>().state.todos.length,
        ),
    update:
        (
          BuildContext context,
          TodoList todoList,
          ActiveTodoCount? activeTodoCount,
        ) => activeTodoCount!..update(todoList),
  ),
  ChangeNotifierProxyProvider3<TodoFilter, TodoSearch, TodoList, FilteredTodos>(
    create:
        (context) => FilteredTodos(
          initialFilteredTodos: context.read<TodoList>().state.todos,
        ),
    update:
        (
          BuildContext context,
          TodoFilter todoFilter,
          TodoSearch todoSearch,
          TodoList todoList,
          FilteredTodos? filteredTodos,
        ) => filteredTodos!..update(todoFilter, todoSearch, todoList),
  ),
];
