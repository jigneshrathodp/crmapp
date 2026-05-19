import 'package:equatable/equatable.dart';
import '../models/product_model/get_product_model.dart';
import '../models/product_model/create_product_model.dart';
import '../models/product_model/update_product_model.dart';
import '../models/product_model/delete_product_model.dart';
// FIX: viewProduct returns single object — use ViewProductModel
import '../models/product_model/view_product_model.dart';

// Sentinel to distinguish "not provided" from explicit null in copyWith.
const Object _sentinel = Object();

class ProductState extends Equatable {
  final bool isLoading;
  final GetproductModel? productList;
  // FIX: was missing — viewProduct (GET /products/{id}) returns single object
  final ViewProductModel? viewedProduct;
  final CreateProductModel? createdProduct;
  final UpdateProductModel? updatedProduct;
  final DeleteProductModel? deletedProduct;
  final String? error;

  const ProductState({
    this.isLoading = false,
    this.productList,
    this.viewedProduct,
    this.createdProduct,
    this.updatedProduct,
    this.deletedProduct,
    this.error,
  });

  ProductState copyWith({
    bool? isLoading,
    GetproductModel? productList,
    ViewProductModel? viewedProduct,
    CreateProductModel? createdProduct,
    UpdateProductModel? updatedProduct,
    DeleteProductModel? deletedProduct,
    Object? error = _sentinel,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      productList: productList ?? this.productList,
      viewedProduct: viewedProduct ?? this.viewedProduct,
      createdProduct: createdProduct ?? this.createdProduct,
      updatedProduct: updatedProduct ?? this.updatedProduct,
      deletedProduct: deletedProduct ?? this.deletedProduct,
      error: error == _sentinel ? this.error : error as String?,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        productList,
        viewedProduct,
        createdProduct,
        updatedProduct,
        deletedProduct,
        error,
      ];
}
