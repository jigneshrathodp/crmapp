class DeleteCategoryModel {
  bool? status;
  String? message;

  DeleteCategoryModel({this.status, this.message});

  DeleteCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
