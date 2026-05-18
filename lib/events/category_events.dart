import 'package:equatable/equatable.dart';

// Events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoryList extends CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final Map<String, dynamic> data;

  const CreateCategory(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateCategory extends CategoryEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateCategory(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteCategory extends CategoryEvent {
  final int id;

  const DeleteCategory(this.id);

  @override
  List<Object?> get props => [id];
}

class ViewCategory extends CategoryEvent {
  final int id;

  const ViewCategory(this.id);

  @override
  List<Object?> get props => [id];
}

// Bloc
