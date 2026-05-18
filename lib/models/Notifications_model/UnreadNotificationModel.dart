class UnreadNotificationModel {
  bool? status;
  List<Data>? data;

  UnreadNotificationModel({this.status, this.data});

  UnreadNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
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
        ? new Advertise.fromJson(json['advertise'])
        : null;
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['status'] = this.status;
    if (this.advertise != null) {
      data['advertise'] = this.advertise!.toJson();
    }
    if (this.order != null) {
      data['order'] = this.order!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['url'] = this.url;
    data['socialmedia'] = this.socialmedia;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customerName;
    data['email'] = this.email;
    return data;
  }
}
