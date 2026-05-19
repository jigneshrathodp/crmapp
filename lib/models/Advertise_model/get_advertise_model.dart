class GetAdvertiseModel {
  bool? status;
  String? message;
  List<Data>? data;

  GetAdvertiseModel({this.status, this.message, this.data});

  GetAdvertiseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? date;
  String? title;
  String? price;
  String? url;
  String? socialmedia;

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
