import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

// Events
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class GetProductList extends ProductEvent {}

class CreateProduct extends ProductEvent {
  final Map<String, String> fields;
  final http.MultipartFile? imageFile;

  const CreateProduct(this.fields, {this.imageFile});

  @override
  List<Object?> get props => [fields];
}

class UpdateProduct extends ProductEvent {
  final int id;
  final Map<String, String> fields;
  final http.MultipartFile? imageFile;

  const UpdateProduct(this.id, this.fields, {this.imageFile});

  @override
  List<Object?> get props => [id, fields];
}

class DeleteProduct extends ProductEvent {
  final int id;

  const DeleteProduct(this.id);

  @override
  List<Object?> get props => [id];
}

class ViewProduct extends ProductEvent {
  final int id;

  const ViewProduct(this.id);

  @override
  List<Object?> get props => [id];
}

// Bloc
