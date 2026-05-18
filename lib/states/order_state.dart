import 'package:equatable/equatable.dart';
import '../models/Order_model/GetOrderModel.dart';
import '../models/Order_model/CreateOrderModel.dart';
import '../models/Order_model/DeleteOrderModel.dart';

class OrderState extends Equatable {
  final bool isLoading;
  final GetOrderModel? orderList;
  final CreateOrderModel? createdOrder;
  final DeleteOrderModel? deletedOrder;
  final String? error;

  const OrderState({
    this.isLoading = false,
    this.orderList,
    this.createdOrder,
    this.deletedOrder,
    this.error,
  });

  OrderState copyWith({
    bool? isLoading,
    GetOrderModel? orderList,
    CreateOrderModel? createdOrder,
    DeleteOrderModel? deletedOrder,
    String? error,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      orderList: orderList ?? this.orderList,
      createdOrder: createdOrder ?? this.createdOrder,
      deletedOrder: deletedOrder ?? this.deletedOrder,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        orderList,
        createdOrder,
        deletedOrder,
        error,
      ];
}
