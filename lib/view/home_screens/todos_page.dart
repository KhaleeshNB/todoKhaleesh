import 'package:share_plus/share_plus.dart';
import 'package:todo/debounce.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/utils/exports.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   _checkIfUserIsLoggedIn();
  // }

  // Future<void> _checkIfUserIsLoggedIn() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   String? userId = prefs.getString('id');
  //   String? userName = prefs.getString('name');
  //   String? userEmail = prefs.getString('email');

  //   if (userId == null && userName == null && userEmail == null) {
  //     print("hi $userName, user ID: $userId");
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const LoginScreen()),
  //     );
  //   } else {
  //     print("No user data found in SharedPreferences.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            children: [
              TodoHeader(),
              CreateTodo(),
              SizedBox(height: 20.h),
              SearchAndFilterTodo(),
              ShowTodos(),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TODO', style: TextStyle(fontSize: 40.sp)),
            TextButton(
              onPressed: () {
                context.read<LoginProvider>().logout(context);
                // Navigator.pushNamedAndRemoveUntil(
                //   context,
                //   RoutesName.login,
                //   (route) => false,
                // );
              },
              child: Text("Logout", style: TextStyle(fontSize: 15.sp)),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          'Hi! ${context.watch<UserAuthProvider>().state.user.name}',
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          '${context.watch<ActiveTodoCount>().state.activeTodoCount} items left',
          style: TextStyle(fontSize: 20.sp, color: Colors.redAccent),
        ),
      ],
    );
  }
}

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final newTodoController = TextEditingController();

  @override
  void dispose() {
    newTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newTodoController,
      decoration: InputDecoration(labelText: "What to do?"),
      onSubmitted: (String? todoDesc) {
        if (todoDesc != null && todoDesc.trim().isNotEmpty) {
          context.read<TodoList>().addTodo(
            todoDesc,
            context.read<UserAuthProvider>().state.user.id,
            context.read<UserAuthProvider>().state.user.name,
          );
          newTodoController.clear();
        }
      },
    );
  }
}

class SearchAndFilterTodo extends StatelessWidget {
  SearchAndFilterTodo({super.key});
  final debounce = Debounce(milliSeconds: 1000);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: "Search Todos",
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (String? newSearchTerm) {
            if (newSearchTerm != null) {
              debounce.run(() {
                context.read<TodoSearch>().setSearchTerm(newSearchTerm);
              });
            }
          },
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            filterButton(context, FilterTodo.all),
            filterButton(context, FilterTodo.active),
            filterButton(context, FilterTodo.completed),
          ],
        ),
      ],
    );
  }

  Widget filterButton(BuildContext context, FilterTodo filter) {
    return TextButton(
      onPressed: () {
        context.read<TodoFilter>().changeFilter(filter);
      },
      child: Text(
        filter == FilterTodo.all
            ? 'All'
            : filter == FilterTodo.active
            ? "Active"
            : "Completed",
        style: TextStyle(fontSize: 18.sp, color: textColor(context, filter)),
      ),
    );
  }

  Color textColor(BuildContext context, FilterTodo filter) {
    final currentFilter = context.watch<TodoFilter>().state.filter;
    return currentFilter == filter ? Colors.blue : Colors.grey;
  }
}

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: context.read<TodoList>().getTodosStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No items available.",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final todos = snapshot.data!;

        context.read<FilteredTodos>().update(
          context.read<TodoFilter>(),
          context.read<TodoSearch>(),
          context.read<TodoList>(),
        );

        final filteredTodos =
            context.watch<FilteredTodos>().state.filteredTodos;

        return ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: filteredTodos.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey),
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(filteredTodos[index].id),
              background: showBackground(0),
              secondaryBackground: showBackground(1),
              onDismissed: (_) {
                context.read<TodoList>().removeTodo(filteredTodos[index]);
              },
              confirmDismiss: (_) {
                return showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Are You Sure?"),
                      content: Text("Do you really want to delete?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("NO"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text("Yes"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: TodoItem(todo: filteredTodos[index]),
            );
          },
        );
      },
    );
  }

  Widget showBackground(int direction) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: Icon(Icons.delete, size: 30.sp, color: Colors.white),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;
  const TodoItem({super.key, required this.todo});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController textController;
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            bool _error = false;
            textController.text = widget.todo.desc;
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: Text('Edit Todo'),
                  content: TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                      errorText: _error ? 'value cannot be empty' : null,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _error = textController.text.isEmpty ? true : false;
                          if (!_error) {
                            print(widget.todo);
                            context.read<TodoList>().editTodo(
                              widget.todo.id,
                              textController.text,
                              context.read<UserAuthProvider>().state.user.id,
                              context.read<UserAuthProvider>().state.user.name,
                            );
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: Text("Edit"),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (bool? checked) {
          context.read<TodoList>().toggleTodo(widget.todo.id);
        },
      ),
      title: Text(widget.todo.desc),
      subtitle:
          widget.todo.ownerId != context.read<UserAuthProvider>().state.user.id
              ? Text(
                "Owner: ${widget.todo.ownerName}, Last Edited By: ${widget.todo.lastEditedByName ?? 'N/A'}",
              )
              : Text("Owner: ${widget.todo.ownerName}"),
      trailing: IconButton(
        icon: Icon(Icons.share),
        onPressed: () {
          final shareMessage = "Check out this task: ${widget.todo.desc}";
          Share.share(shareMessage);
        },
      ),
    );
  }
}
