import 'package:equatable/equatable.dart';
import '../models/Category_model/get_catgory_model.dart';
import '../models/Category_model/create_category_model.dart';
import '../models/Category_model/update_category_model.dart';
import '../models/Category_model/delete_category_model.dart';
// FIX: viewCategory returns single object — use ViewCategoryModel
import '../models/Category_model/view_category_model.dart';

// Sentinel to distinguish "not provided" from explicit null in copyWith.
const Object _sentinel = Object();

class CategoryState extends Equatable {
  final bool isLoading;
  final GetCatgoryModel? categoryList;
  // FIX: was missing — viewCategory (GET /categories/{id}) returns single object
  final ViewCategoryModel? viewedCategory;
  final CreateCategoryModel? createdCategory;
  final UpdateCategoryModel? updatedCategory;
  final DeleteCategoryModel? deletedCategory;
  final String? error;

  const CategoryState({
    this.isLoading = false,
    this.categoryList,
    this.viewedCategory,
    this.createdCategory,
    this.updatedCategory,
    this.deletedCategory,
    this.error,
  });

  CategoryState copyWith({
    bool? isLoading,
    GetCatgoryModel? categoryList,
    ViewCategoryModel? viewedCategory,
    CreateCategoryModel? createdCategory,
    UpdateCategoryModel? updatedCategory,
    DeleteCategoryModel? deletedCategory,
    Object? error = _sentinel,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      categoryList: categoryList ?? this.categoryList,
      viewedCategory: viewedCategory ?? this.viewedCategory,
      createdCategory: createdCategory ?? this.createdCategory,
      updatedCategory: updatedCategory ?? this.updatedCategory,
      deletedCategory: deletedCategory ?? this.deletedCategory,
      error: error == _sentinel ? this.error : error as String?,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        categoryList,
        viewedCategory,
        createdCategory,
        updatedCategory,
        deletedCategory,
        error,
      ];
}
