// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import 'package:todo/utils/exports.dart';

Uuid uuid = Uuid();

class Todo extends Equatable {
  final String id;
  final String desc;
  final bool completed;
  final String ownerId;
  final String ownerName;
  final String? lastEditedById;
  final String? lastEditedByName;

  Todo({
    String? id,
    required this.desc,
    this.completed = false,
    required this.ownerId,
    required this.ownerName,
    this.lastEditedById,
    this.lastEditedByName,
  }) : id = id ?? uuid.v4();

  @override
  List<Object> get props {
    return [
      id,
      desc,
      completed,
      ownerId,
      ownerName,
      lastEditedById ?? '',
      lastEditedByName ?? '',
    ];
  }

  @override
  bool get stringify => true;

  Todo copyWith({
    String? id,
    String? desc,
    bool? completed,
    String? ownerId,
    String? ownerName,
    String? lastEditedById,
    String? lastEditedByName,
  }) {
    return Todo(
      id: id ?? this.id,
      desc: desc ?? this.desc,
      completed: completed ?? this.completed,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      lastEditedById: lastEditedById ?? this.lastEditedById,
      lastEditedByName: lastEditedByName ?? this.lastEditedByName,
    );
  }
}

enum FilterTodo { all, active, completed }
