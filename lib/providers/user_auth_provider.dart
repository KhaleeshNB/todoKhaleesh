import 'package:todo/utils/exports.dart';

class UserAuthProviderState extends Equatable {
  final UserAuth user;

  UserAuthProviderState({required this.user});

  factory UserAuthProviderState.initial() {
    return UserAuthProviderState(user: UserAuth(id: '', name: '', email: ''));
  }
  @override
  List<Object> get props => [user];

  @override
  bool get stringify => true;

  UserAuthProviderState copyWith({UserAuth? user}) {
    return UserAuthProviderState(user: user ?? this.user);
  }
}

class UserAuthProvider with ChangeNotifier {
  UserAuthProviderState _state = UserAuthProviderState.initial();
  UserAuthProviderState get state => _state;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? name = prefs.getString('name');
    String? email = prefs.getString('email');

    if (id != null && name != null && email != null) {
      _state = _state.copyWith(
        user: UserAuth(id: id, name: name, email: email),
      );
    }
    notifyListeners();
  }

  Future<void> saveUserData(UserAuth user) async {
    print('${user.id}, ${user.name}');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);

    _state = _state.copyWith(user: user);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('name');
    await prefs.remove('email');
    _state = _state.copyWith(user: UserAuth(id: '', name: '', email: ''));
    notifyListeners();
  }
}
