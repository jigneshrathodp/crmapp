import 'package:equatable/equatable.dart';

// Events
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class GetProductList extends ProductEvent {}

class CreateProduct extends ProductEvent {
  final Map<String, dynamic> data;

  const CreateProduct(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateProduct extends ProductEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateProduct(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
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
