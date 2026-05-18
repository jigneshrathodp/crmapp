import 'package:flutter_bloc/flutter_bloc.dart';

import '../all_api_calls/all_api_calls.dart';
import '../events/category_events.dart';
import '../states/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AllApiCalls _apiCalls;

  CategoryBloc(this._apiCalls) : super(CategoryState()) {
    on<GetCategoryList>(_onGetCategoryList);
    on<CreateCategory>(_onCreateCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<ViewCategory>(_onViewCategory);
  }

  Future<void> _onGetCategoryList(
    GetCategoryList event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final categories = await _apiCalls.getCategoryList();
      emit(state.copyWith(isLoading: false, categoryList: categories));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreateCategory(
    CreateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final created = await _apiCalls.createCategory(event.data);
      emit(state.copyWith(isLoading: false, createdCategory: created));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updated = await _apiCalls.updateCategory(event.id, event.data);
      emit(state.copyWith(isLoading: false, updatedCategory: updated));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final deleted = await _apiCalls.deleteCategory(event.id);
      emit(state.copyWith(isLoading: false, deletedCategory: deleted));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onViewCategory(
    ViewCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final category = await _apiCalls.viewCategory(event.id);
      emit(state.copyWith(isLoading: false, categoryList: category));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
