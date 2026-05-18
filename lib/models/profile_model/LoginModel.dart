class LoginModel {
  bool? status;
  String? message;
  String? token;

  LoginModel({this.status, this.message, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    return data;
  }
}
