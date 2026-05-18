import 'package:flutter_bloc/flutter_bloc.dart';

import '../all_api_calls/all_api_calls.dart';
import '../events/order_events.dart';
import '../states/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final AllApiCalls _apiCalls;

  OrderBloc(this._apiCalls) : super(OrderState()) {
    on<GetOrderList>(_onGetOrderList);
    on<CreateOrder>(_onCreateOrder);
    on<DeleteOrder>(_onDeleteOrder);
    on<GetOrderDetail>(_onGetOrderDetail);
  }

  Future<void> _onGetOrderList(
    GetOrderList event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final orders = await _apiCalls.getOrderList();
      emit(state.copyWith(isLoading: false, orderList: orders));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final created = await _apiCalls.createOrder(event.data);
      emit(state.copyWith(isLoading: false, createdOrder: created));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteOrder(
    DeleteOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final deleted = await _apiCalls.deleteOrder(event.id);
      emit(state.copyWith(isLoading: false, deletedOrder: deleted));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onGetOrderDetail(
    GetOrderDetail event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final order = await _apiCalls.getOrderDetail(event.id);
      emit(state.copyWith(isLoading: false, orderList: order));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
