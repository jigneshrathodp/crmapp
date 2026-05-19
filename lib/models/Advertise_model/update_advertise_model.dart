class UpdateAdvertiseModel {
  bool? status;
  String? message;
  Data? data;

  UpdateAdvertiseModel({this.status, this.message, this.data});

  UpdateAdvertiseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic date;
  dynamic title;
  dynamic price;
  dynamic url;
  dynamic socialmedia;

  Data({
    this.id,
    this.date,
    this.title,
    this.price,
    this.url,
    this.socialmedia,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    title = json['title'];
    price = json['price'];
    url = json['url'];
    socialmedia = json['socialmedia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['title'] = title;
    data['price'] = price;
    data['url'] = url;
    data['socialmedia'] = socialmedia;
    return data;
  }
}
