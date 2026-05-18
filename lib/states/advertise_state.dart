import 'package:equatable/equatable.dart';
import '../models/Advertise_model/GetAdvertiseModel.dart';
import '../models/Advertise_model/CreateAdvertiseModel.dart';
import '../models/Advertise_model/UpdateAdvertiseModel.dart';
import '../models/Advertise_model/DeleteAdvertiseModel.dart';

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
    String? error,
  }) {
    return AdvertiseState(
      isLoading: isLoading ?? this.isLoading,
      advertiseList: advertiseList ?? this.advertiseList,
      createdAdvertise: createdAdvertise ?? this.createdAdvertise,
      updatedAdvertise: updatedAdvertise ?? this.updatedAdvertise,
      deletedAdvertise: deletedAdvertise ?? this.deletedAdvertise,
      error: error ?? this.error,
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
