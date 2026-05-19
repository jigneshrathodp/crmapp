// Model for GET /categories/{id} — returns a single category object under "data"
class ViewCategoryModel {
  bool? status;
  String? message;
  Data? data;

  ViewCategoryModel({this.status, this.message, this.data});

  ViewCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    data = json['data'] != null ? Data.fromJson(json['data'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['status'] = status;
    result['message'] = message;
    if (data != null) result['data'] = data!.toJson();
    return result;
  }
}

class Data {
  int? id;
  String? name;
  String? skubarCode;
  String? image;

  Data({this.id, this.name, this.skubarCode, this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']?.toString();
    skubarCode = json['skubar_code']?.toString();
    image = json['image']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'skubar_code': skubarCode,
      'image': image,
    };
  }
}
