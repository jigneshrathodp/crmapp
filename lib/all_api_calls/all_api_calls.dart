import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base_api/base_api.dart';
import '../api_url.dart';
import '../models/Category_model/get_catgory_model.dart';
import '../models/Category_model/create_category_model.dart';
import '../models/Category_model/update_category_model.dart';
import '../models/Category_model/delete_category_model.dart';
import '../models/Category_model/view_category_model.dart';
import '../models/product_model/get_product_model.dart';
import '../models/product_model/create_product_model.dart';
import '../models/product_model/update_product_model.dart';
import '../models/product_model/delete_product_model.dart';
import '../models/product_model/view_product_model.dart';
import '../models/Order_model/get_order_model.dart';
import '../models/Order_model/create_order_model.dart';
import '../models/Order_model/delete_order_model.dart';
import '../models/Order_model/view_order_model.dart';
import '../models/Advertise_model/get_advertise_model.dart';
import '../models/Advertise_model/create_advertise_model.dart';
import '../models/Advertise_model/update_advertise_model.dart';
import '../models/Advertise_model/delete_advertise_model.dart';

class AllApiCalls {
  final BaseApi _baseApi;

  AllApiCalls(this._baseApi);
  String _path(String fullUrl) => fullUrl.replaceFirst(ApiUrls.baseUrl, '');

  // Auth APIs
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await _baseApi.post(_path(ApiUrls.login), body: data);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await _baseApi.post(_path(ApiUrls.logout));
    return jsonDecode(response.body);
  }

  // Profile APIs
  Future<Map<String, dynamic>> getProfileDetails() async {
    final response = await _baseApi.get(_path(ApiUrls.profileDetails));
    return jsonDecode(response.body);
  }

  /// Update profile using multipart/form-data (supports file uploads).
  /// [textFields]: text fields (name, email, contact, site_name, footer, address)
  /// [imageFiles]: map of field-name → MultipartFile (image, fav_icon, logo_dark, logo_light)
  Future<Map<String, dynamic>> updateProfile(
    Map<String, String> textFields, {
    Map<String, http.MultipartFile>? imageFiles,
  }) async {
    final files = imageFiles?.entries
        .map((e) => http.MultipartFile(
              e.key,
              e.value.finalize(),
              e.value.length,
              filename: e.value.filename,
              contentType: e.value.contentType,
            ))
        .toList();
    final response = await _baseApi.postMultipart(
      _path(ApiUrls.updateProfile),
      fields: textFields,
      files: files,
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) async {
    final response = await _baseApi.post(
      _path(ApiUrls.resetPassword),
      body: data,
    );
    return jsonDecode(response.body);
  }

  // Dashboard API
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _baseApi.get(_path(ApiUrls.dashboard));
    return jsonDecode(response.body);
  }

  // Category APIs
  Future<GetCatgoryModel> getCategoryList() async {
    final response = await _baseApi.get(_path(ApiUrls.categoryList));
    return GetCatgoryModel.fromJson(jsonDecode(response.body));
  }

  /// Create category with multipart (name, skubar_code, image file required).
  Future<CreateCategoryModel> createCategory(
    Map<String, String> textFields, {
    http.MultipartFile? imageFile,
  }) async {
    final response = await _baseApi.postMultipart(
      _path(ApiUrls.categoryCreate),
      fields: textFields,
      files: imageFile != null ? [imageFile] : [],
    );
    return CreateCategoryModel.fromJson(jsonDecode(response.body));
  }

  /// FIX: API GET /categories/{id} returns single object — use ViewCategoryModel, not GetCatgoryModel.
  Future<ViewCategoryModel> viewCategory(int id) async {
    final response = await _baseApi.get(_path(ApiUrls.categoryView(id)));
    return ViewCategoryModel.fromJson(jsonDecode(response.body));
  }

  /// Update category with multipart + _method=PUT (Laravel method spoofing).
  Future<UpdateCategoryModel> updateCategory(
    int id,
    Map<String, String> textFields, {
    http.MultipartFile? imageFile,
  }) async {
    // Laravel requires _method=PUT for multipart PUT via POST route
    final fields = Map<String, String>.from(textFields);
    fields['_method'] = 'PUT';
    final response = await _baseApi.postMultipart(
      _path(ApiUrls.categoryUpdate(id)),
      fields: fields,
      files: imageFile != null ? [imageFile] : [],
    );
    return UpdateCategoryModel.fromJson(jsonDecode(response.body));
  }

  Future<DeleteCategoryModel> deleteCategory(int id) async {
    final response = await _baseApi.delete(_path(ApiUrls.categoryDelete(id)));
    return DeleteCategoryModel.fromJson(jsonDecode(response.body));
  }

  // Product APIs
  Future<GetproductModel> getProductList() async {
    final response = await _baseApi.get(_path(ApiUrls.productList));
    return GetproductModel.fromJson(jsonDecode(response.body));
  }

  /// Create product with multipart (name, category, qnty, weight_in_gram,
  /// cost_per_gram, sts, for_sale, sell_price optional, image file).
  Future<CreateProductModel> createProduct(
    Map<String, String> textFields, {
    http.MultipartFile? imageFile,
  }) async {
    final response = await _baseApi.postMultipart(
      _path(ApiUrls.productCreate),
      fields: textFields,
      files: imageFile != null ? [imageFile] : [],
    );
    return CreateProductModel.fromJson(jsonDecode(response.body));
  }

  /// FIX: API GET /products/{id} returns single object — use ViewProductModel, not GetproductModel.
  Future<ViewProductModel> viewProduct(int id) async {
    final response = await _baseApi.get(_path(ApiUrls.productView(id)));
    return ViewProductModel.fromJson(jsonDecode(response.body));
  }

  /// Update product with multipart + _method=PUT (Laravel method spoofing).
  Future<UpdateProductModel> updateProduct(
    int id,
    Map<String, String> textFields, {
    http.MultipartFile? imageFile,
  }) async {
    final fields = Map<String, String>.from(textFields);
    fields['_method'] = 'PUT';
    final response = await _baseApi.postMultipart(
      _path(ApiUrls.productUpdate(id)),
      fields: fields,
      files: imageFile != null ? [imageFile] : [],
    );
    return UpdateProductModel.fromJson(jsonDecode(response.body));
  }

  Future<DeleteProductModel> deleteProduct(int id) async {
    final response = await _baseApi.delete(_path(ApiUrls.productDelete(id)));
    return DeleteProductModel.fromJson(jsonDecode(response.body));
  }

  // Order APIs
  Future<GetOrderModel> getOrderList() async {
    final response = await _baseApi.get(_path(ApiUrls.orderList));
    return GetOrderModel.fromJson(jsonDecode(response.body));
  }

  Future<CreateOrderModel> createOrder(Map<String, dynamic> data) async {
    final response = await _baseApi.post(
      _path(ApiUrls.orderCreate),
      body: data,
    );
    return CreateOrderModel.fromJson(jsonDecode(response.body));
  }

  /// FIX: API GET /orders/{id} returns single object — use ViewOrderModel, not GetOrderModel.
  Future<ViewOrderModel> getOrderDetail(int id) async {
    final response = await _baseApi.get(_path(ApiUrls.orderDetail(id)));
    return ViewOrderModel.fromJson(jsonDecode(response.body));
  }

  Future<DeleteOrderModel> deleteOrder(int id) async {
    final response = await _baseApi.delete(_path(ApiUrls.orderDelete(id)));
    return DeleteOrderModel.fromJson(jsonDecode(response.body));
  }

  // Advertise APIs
  Future<GetAdvertiseModel> getAdvertiseList() async {
    final response = await _baseApi.get(_path(ApiUrls.advertiseList));
    return GetAdvertiseModel.fromJson(jsonDecode(response.body));
  }

  Future<CreateAdvertiseModel> createAdvertise(
    Map<String, dynamic> data,
  ) async {
    final response = await _baseApi.post(
      _path(ApiUrls.advertiseCreate),
      body: data,
    );
    return CreateAdvertiseModel.fromJson(jsonDecode(response.body));
  }

  Future<UpdateAdvertiseModel> updateAdvertise(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await _baseApi.put(
      _path(ApiUrls.advertiseUpdate(id)),
      body: data,
    );
    return UpdateAdvertiseModel.fromJson(jsonDecode(response.body));
  }

  Future<DeleteAdvertiseModel> deleteAdvertise(int id) async {
    final response = await _baseApi.delete(_path(ApiUrls.advertiseDelete(id)));
    return DeleteAdvertiseModel.fromJson(jsonDecode(response.body));
  }

  // Notification APIs
  Future<Map<String, dynamic>> getUnreadNotifications() async {
    final response = await _baseApi.get(_path(ApiUrls.unreadNotifications));
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getReadNotifications() async {
    final response = await _baseApi.get(_path(ApiUrls.readNotifications));
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> markNotificationRead(int id) async {
    final response = await _baseApi.put(
      _path(ApiUrls.markNotificationRead(id)),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> markAllNotificationsRead() async {
    final response = await _baseApi.put(
      _path(ApiUrls.markAllNotificationsRead),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deleteNotification(int id) async {
    final response = await _baseApi.delete(
      _path(ApiUrls.notificationDelete(id)),
    );
    return jsonDecode(response.body);
  }
}
