import 'package:equatable/equatable.dart';
import '../models/Category_model/GetCatgoryModel.dart';
import '../models/Category_model/CreateCategoryModel.dart';
import '../models/Category_model/UpdateCategoryModel.dart';
import '../models/Category_model/DeleteCategoryModel.dart';

class CategoryState extends Equatable {
  final bool isLoading;
  final GetCatgoryModel? categoryList;
  final CreateCategoryModel? createdCategory;
  final UpdateCategoryModel? updatedCategory;
  final DeleteCategoryModel? deletedCategory;
  final String? error;

  const CategoryState({
    this.isLoading = false,
    this.categoryList,
    this.createdCategory,
    this.updatedCategory,
    this.deletedCategory,
    this.error,
  });

  CategoryState copyWith({
    bool? isLoading,
    GetCatgoryModel? categoryList,
    CreateCategoryModel? createdCategory,
    UpdateCategoryModel? updatedCategory,
    DeleteCategoryModel? deletedCategory,
    String? error,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      categoryList: categoryList ?? this.categoryList,
      createdCategory: createdCategory ?? this.createdCategory,
      updatedCategory: updatedCategory ?? this.updatedCategory,
      deletedCategory: deletedCategory ?? this.deletedCategory,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        categoryList,
        createdCategory,
        updatedCategory,
        deletedCategory,
        error,
      ];
}
