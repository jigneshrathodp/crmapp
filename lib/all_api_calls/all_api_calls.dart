import 'dart:convert';
import '../base_api/base_api.dart';
import '../api_url.dart';
import '../models/Category_model/GetCatgoryModel.dart';
import '../models/Category_model/CreateCategoryModel.dart';
import '../models/Category_model/UpdateCategoryModel.dart';
import '../models/Category_model/DeleteCategoryModel.dart';
import '../models/product_model/GetproductModel.dart';
import '../models/product_model/CreateProductModel.dart';
import '../models/product_model/UpdateProductModel.dart';
import '../models/product_model/DeleteProductModel.dart';
import '../models/Order_model/GetOrderModel.dart';
import '../models/Order_model/CreateOrderModel.dart';
import '../models/Order_model/DeleteOrderModel.dart';
import '../models/Advertise_model/GetAdvertiseModel.dart';
import '../models/Advertise_model/CreateAdvertiseModel.dart';
import '../models/Advertise_model/UpdateAdvertiseModel.dart';
import '../models/Advertise_model/DeleteAdvertiseModel.dart';

class AllApiCalls {
  final BaseApi _baseApi;

  AllApiCalls(this._baseApi);

  // Helper to strip base URL prefix from full URL
  String _path(String fullUrl) =>
      fullUrl.replaceFirst(ApiUrls.baseUrl, '');

  // Auth APIs
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await _baseApi.post(
      _path(ApiUrls.login),
      body: data,
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await _baseApi.post(
      _path(ApiUrls.logout),
    );
    return jsonDecode(response.body);
  }

  // Profile APIs
  Future<Map<String, dynamic>> getProfileDetails() async {
    final response = await _baseApi.get(
      _path(ApiUrls.profileDetails),
    );
    return jsonDecode(response.body);
  }

  // Fixed: API expects POST (multipart formdata), using POST here
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _baseApi.post(
      _path(ApiUrls.updateProfile),
      body: data,
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
    final response = await _baseApi.get(
      _path(ApiUrls.dashboard),
    );
    return jsonDecode(response.body);
  }

  // Category APIs
  Future<GetCatgoryModel> getCategoryList() async {
    final response = await _baseApi.get(
      _path(ApiUrls.categoryList),
    );
    return GetCatgoryModel.fromJson(jsonDecode(response.body));
  }

  Future<CreateCategoryModel> createCategory(Map<String, dynamic> data) async {
    final response = await _baseApi.post(
      _path(ApiUrls.categoryCreate),
      body: data,
    );
    return CreateCategoryModel.fromJson(jsonDecode(response.body));
  }

  Future<GetCatgoryModel> viewCategory(int id) async {
    final response = await _baseApi.get(
      _path(ApiUrls.categoryView(id)),
    );
    return GetCatgoryModel.fromJson(jsonDecode(response.body));
  }

  Future<UpdateCategoryModel> updateCategory(int id, Map<String, dynamic> data) async {
    final response = await _baseApi.post(
      _path(ApiUrls.categoryUpdate(id)),
      body: data,
    );
    return UpdateCategoryModel.fromJson(jsonDecode(response.body));
  }

  Future<DeleteCategoryModel> deleteCategory(int id) async {
    final response = await _baseApi.delete(
      _path(ApiUrls.categoryDelete(id)),
    );
    return DeleteCategoryModel.fromJson(jsonDecode(response.body));
  }

  // Product APIs
  Future<GetproductModel> getProductList() async {
    final response = await _baseApi.get(
      _path(ApiUrls.productList),
    );
    return GetproductModel.fromJson(jsonDecode(response.body));
  }

  Future<CreateProductModel> createProduct(Map<String, dynamic> data) async {
    final response = await _baseApi.post(
      _path(ApiUrls.productCreate),
      body: data,
    );
    return CreateProductModel.fromJson(jsonDecode(response.body));
  }

  Future<GetproductModel> viewProduct(int id) async {
    final response = await _baseApi.get(
      _path(ApiUrls.productView(id)),
    );
    return GetproductModel.fromJson(jsonDecode(response.body));
  }

  Future<UpdateProductModel> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await _baseApi.post(
      _path(ApiUrls.productUpdate(id)),
      body: data,
    );
    return UpdateProductModel.fromJson(jsonDecode(response.body));
  }

  Future<DeleteProductModel> deleteProduct(int id) async {
    final response = await _baseApi.delete(
      _path(ApiUrls.productDelete(id)),
    );
    return DeleteProductModel.fromJson(jsonDecode(response.body));
  }

  // Order APIs
  Future<GetOrderModel> getOrderList() async {
    final response = await _baseApi.get(
      _path(ApiUrls.orderList),
    );
    return GetOrderModel.fromJson(jsonDecode(response.body));
  }

  Future<CreateOrderModel> createOrder(Map<String, dynamic> data) async {
    final response = await _baseApi.post(
      _path(ApiUrls.orderCreate),
      body: data,
    );
    return CreateOrderModel.fromJson(jsonDecode(response.body));
  }

  Future<GetOrderModel> getOrderDetail(int id) async {
    final response = await _baseApi.get(
      _path(ApiUrls.orderDetail(id)),
    );
    return GetOrderModel.fromJson(jsonDecode(response.body));
  }

  Future<DeleteOrderModel> deleteOrder(int id) async {
    final response = await _baseApi.delete(
      _path(ApiUrls.orderDelete(id)),
    );
    return DeleteOrderModel.fromJson(jsonDecode(response.body));
  }

  // Advertise APIs
  Future<GetAdvertiseModel> getAdvertiseList() async {
    final response = await _baseApi.get(
      _path(ApiUrls.advertiseList),
    );
    return GetAdvertiseModel.fromJson(jsonDecode(response.body));
  }

  Future<CreateAdvertiseModel> createAdvertise(Map<String, dynamic> data) async {
    final response = await _baseApi.post(
      _path(ApiUrls.advertiseCreate),
      body: data,
    );
    return CreateAdvertiseModel.fromJson(jsonDecode(response.body));
  }

  Future<UpdateAdvertiseModel> updateAdvertise(int id, Map<String, dynamic> data) async {
    final response = await _baseApi.put(
      _path(ApiUrls.advertiseUpdate(id)),
      body: data,
    );
    return UpdateAdvertiseModel.fromJson(jsonDecode(response.body));
  }

  Future<DeleteAdvertiseModel> deleteAdvertise(int id) async {
    final response = await _baseApi.delete(
      _path(ApiUrls.advertiseDelete(id)),
    );
    return DeleteAdvertiseModel.fromJson(jsonDecode(response.body));
  }

  // Notification APIs
  Future<Map<String, dynamic>> getUnreadNotifications() async {
    final response = await _baseApi.get(
      _path(ApiUrls.unreadNotifications),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getReadNotifications() async {
    final response = await _baseApi.get(
      _path(ApiUrls.readNotifications),
    );
    return jsonDecode(response.body);
  }

  // Fixed: API uses PUT, and markNotificationRead is now a function
  Future<Map<String, dynamic>> markNotificationRead(int id) async {
    final response = await _baseApi.put(
      _path(ApiUrls.markNotificationRead(id)),
    );
    return jsonDecode(response.body);
  }

  // Fixed: API uses PUT
  Future<Map<String, dynamic>> markAllNotificationsRead() async {
    final response = await _baseApi.put(
      _path(ApiUrls.markAllNotificationsRead),
    );
    return jsonDecode(response.body);
  }

  // Fixed: notificationDelete is now a function
  Future<Map<String, dynamic>> deleteNotification(int id) async {
    final response = await _baseApi.delete(
      _path(ApiUrls.notificationDelete(id)),
    );
    return jsonDecode(response.body);
  }
}
