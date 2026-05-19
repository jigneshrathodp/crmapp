class UnreadNotificationModel {
  bool? status;
  List<Data>? data;

  UnreadNotificationModel({this.status, this.data});

  UnreadNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? type;
  String? status;
  Advertise? advertise;
  Order? order;

  Data({this.id, this.type, this.status, this.advertise, this.order});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    status = json['status'];
    advertise = json['advertise'] != null
        ? Advertise.fromJson(json['advertise'])
        : null;
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['status'] = status;
    if (advertise != null) {
      data['advertise'] = advertise!.toJson();
    }
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Advertise {
  String? title;
  String? url;
  String? socialmedia;

  Advertise({this.title, this.url, this.socialmedia});

  Advertise.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    url = json['url'];
    socialmedia = json['socialmedia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['url'] = url;
    data['socialmedia'] = socialmedia;
    return data;
  }
}

class Order {
  String? customerName;
  String? email;

  Order({this.customerName, this.email});

  Order.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = customerName;
    data['email'] = email;
    return data;
  }
}
