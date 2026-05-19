import 'package:flutter_bloc/flutter_bloc.dart';

import '../all_api_calls/all_api_calls.dart';
import '../events/product_events.dart';
import '../states/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AllApiCalls _apiCalls;

  ProductBloc(this._apiCalls) : super(ProductState()) {
    on<GetProductList>(_onGetProductList);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<ViewProduct>(_onViewProduct);
  }

  Future<void> _onGetProductList(
    GetProductList event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final products = await _apiCalls.getProductList();
      emit(state.copyWith(isLoading: false, productList: products));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final created = await _apiCalls.createProduct(
        event.fields,
        imageFile: event.imageFile,
      );
      emit(state.copyWith(isLoading: false, createdProduct: created));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updated = await _apiCalls.updateProduct(
        event.id,
        event.fields,
        imageFile: event.imageFile,
      );
      emit(state.copyWith(isLoading: false, updatedProduct: updated));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final deleted = await _apiCalls.deleteProduct(event.id);
      emit(state.copyWith(isLoading: false, deletedProduct: deleted));
      add(GetProductList());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onViewProduct(
    ViewProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final product = await _apiCalls.viewProduct(event.id);
      // FIX: was emitting productList (wrong type) — now emits viewedProduct
      emit(state.copyWith(isLoading: false, viewedProduct: product));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
