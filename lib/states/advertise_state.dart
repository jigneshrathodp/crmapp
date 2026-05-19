import 'package:equatable/equatable.dart';
import '../models/Advertise_model/get_advertise_model.dart';
import '../models/Advertise_model/create_advertise_model.dart';
import '../models/Advertise_model/update_advertise_model.dart';
import '../models/Advertise_model/delete_advertise_model.dart';

// Sentinel to distinguish "not provided" from explicit null in copyWith.
const Object _sentinel = Object();

class AdvertiseState extends Equatable {
  final bool isLoading;
  final GetAdvertiseModel? advertiseList;
  final CreateAdvertiseModel? createdAdvertise;
  final UpdateAdvertiseModel? updatedAdvertise;
  final DeleteAdvertiseModel? deletedAdvertise;
  final String? error;

  const AdvertiseState({
    this.isLoading = false,
    this.advertiseList,
    this.createdAdvertise,
    this.updatedAdvertise,
    this.deletedAdvertise,
    this.error,
  });

  AdvertiseState copyWith({
    bool? isLoading,
    GetAdvertiseModel? advertiseList,
    CreateAdvertiseModel? createdAdvertise,
    UpdateAdvertiseModel? updatedAdvertise,
    DeleteAdvertiseModel? deletedAdvertise,
    Object? error = _sentinel,
  }) {
    return AdvertiseState(
      isLoading: isLoading ?? this.isLoading,
      advertiseList: advertiseList ?? this.advertiseList,
      createdAdvertise: createdAdvertise ?? this.createdAdvertise,
      updatedAdvertise: updatedAdvertise ?? this.updatedAdvertise,
      deletedAdvertise: deletedAdvertise ?? this.deletedAdvertise,
      error: error == _sentinel ? this.error : error as String?,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        advertiseList,
        createdAdvertise,
        updatedAdvertise,
        deletedAdvertise,
        error,
      ];
}
