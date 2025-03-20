import 'package:todo/model/todo_model.dart';
import 'package:todo/utils/exports.dart';

class TodoFilterState extends Equatable {
  final FilterTodo filter;

  TodoFilterState({required this.filter});

  factory TodoFilterState.initial() {
    return TodoFilterState(filter: FilterTodo.all);
  }

  @override
  List<Object> get props => [filter];

  @override
  bool get stringify => true;

  TodoFilterState copyWith({FilterTodo? filter}) {
    return TodoFilterState(filter: filter ?? this.filter);
  }
}

class TodoFilter with ChangeNotifier {
  TodoFilterState _state = TodoFilterState.initial();
  TodoFilterState get state => _state;

  void changeFilter(FilterTodo newFilter) {
    _state = _state.copyWith(filter: newFilter);
    notifyListeners();
  }
}
