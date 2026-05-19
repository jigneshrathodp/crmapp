import 'package:equatable/equatable.dart';
import '../models/Order_model/get_order_model.dart';
import '../models/Order_model/create_order_model.dart';
import '../models/Order_model/delete_order_model.dart';

// Sentinel to distinguish "not provided" from explicit null in copyWith.
const Object _sentinel = Object();

class OrderState extends Equatable {
  final bool isLoading;
  final GetOrderModel? orderList;
  final GetOrderModel? orderDetail;
  final CreateOrderModel? createdOrder;
  final DeleteOrderModel? deletedOrder;
  final String? error;

  const OrderState({
    this.isLoading = false,
    this.orderList,
    this.orderDetail,
    this.createdOrder,
    this.deletedOrder,
    this.error,
  });

  OrderState copyWith({
    bool? isLoading,
    GetOrderModel? orderList,
    GetOrderModel? orderDetail,
    CreateOrderModel? createdOrder,
    DeleteOrderModel? deletedOrder,
    Object? error = _sentinel,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      orderList: orderList ?? this.orderList,
      orderDetail: orderDetail ?? this.orderDetail,
      createdOrder: createdOrder ?? this.createdOrder,
      deletedOrder: deletedOrder ?? this.deletedOrder,
      error: error == _sentinel ? this.error : error as String?,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        orderList,
        orderDetail,
        createdOrder,
        deletedOrder,
        error,
      ];
}
