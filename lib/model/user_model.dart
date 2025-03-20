import 'package:todo/utils/exports.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class UserAuth extends Equatable {
  final String id;
  final String name;
  final String email;

  UserAuth({String? id, required this.name, required this.email})
    : id = id ?? uuid.v4();

  @override
  List<Object> get props => [id, name, email];

  @override
  bool get stringify => true;

  UserAuth copyWith({String? id, String? name, String? email}) {
    return UserAuth(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
