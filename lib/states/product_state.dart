import 'package:equatable/equatable.dart';
import '../models/product_model/GetproductModel.dart';
import '../models/product_model/CreateProductModel.dart';
import '../models/product_model/UpdateProductModel.dart';
import '../models/product_model/DeleteProductModel.dart';

class ProductState extends Equatable {
  final bool isLoading;
  final GetproductModel? productList;
  final CreateProductModel? createdProduct;
  final UpdateProductModel? updatedProduct;
  final DeleteProductModel? deletedProduct;
  final String? error;

  const ProductState({
    this.isLoading = false,
    this.productList,
    this.createdProduct,
    this.updatedProduct,
    this.deletedProduct,
    this.error,
  });

  ProductState copyWith({
    bool? isLoading,
    GetproductModel? productList,
    CreateProductModel? createdProduct,
    UpdateProductModel? updatedProduct,
    DeleteProductModel? deletedProduct,
    String? error,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      productList: productList ?? this.productList,
      createdProduct: createdProduct ?? this.createdProduct,
      updatedProduct: updatedProduct ?? this.updatedProduct,
      deletedProduct: deletedProduct ?? this.deletedProduct,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        productList,
        createdProduct,
        updatedProduct,
        deletedProduct,
        error,
      ];
}
