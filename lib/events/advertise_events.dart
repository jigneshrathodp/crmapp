import 'package:equatable/equatable.dart';

// Events
abstract class AdvertiseEvent extends Equatable {
  const AdvertiseEvent();

  @override
  List<Object?> get props => [];
}

class GetAdvertiseList extends AdvertiseEvent {}

class CreateAdvertise extends AdvertiseEvent {
  final Map<String, dynamic> data;

  const CreateAdvertise(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateAdvertise extends AdvertiseEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateAdvertise(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteAdvertise extends AdvertiseEvent {
  final int id;

  const DeleteAdvertise(this.id);

  @override
  List<Object?> get props => [id];
}

// Bloc
