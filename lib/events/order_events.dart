import 'package:equatable/equatable.dart';

// Events
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class GetOrderList extends OrderEvent {}

class CreateOrder extends OrderEvent {
  final Map<String, dynamic> data;

  const CreateOrder(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteOrder extends OrderEvent {
  final int id;

  const DeleteOrder(this.id);

  @override
  List<Object?> get props => [id];
}

class GetOrderDetail extends OrderEvent {
  final int id;

  const GetOrderDetail(this.id);

  @override
  List<Object?> get props => [id];
}

// Bloc
