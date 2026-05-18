import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

// Events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoryList extends CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final Map<String, String> fields;
  final http.MultipartFile? imageFile;

  const CreateCategory(this.fields, {this.imageFile});

  @override
  List<Object?> get props => [fields];
}

class UpdateCategory extends CategoryEvent {
  final int id;
  final Map<String, String> fields;
  final http.MultipartFile? imageFile;

  const UpdateCategory(this.id, this.fields, {this.imageFile});

  @override
  List<Object?> get props => [id, fields];
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
