class CreateAdvertiseModel {
  bool? status;
  String? message;
  Data? data;

  CreateAdvertiseModel({this.status, this.message, this.data});

  CreateAdvertiseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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

  Data(
      {this.id, this.date, this.title, this.price, this.url, this.socialmedia});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    title = json['title'];
    price = json['price'];
    url = json['url'];
    socialmedia = json['socialmedia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['title'] = this.title;
    data['price'] = this.price;
    data['url'] = this.url;
    data['socialmedia'] = this.socialmedia;
    return data;
  }
}
