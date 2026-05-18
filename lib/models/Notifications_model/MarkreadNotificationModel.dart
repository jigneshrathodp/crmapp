class MarkreadNotificationModel {
  bool? status;
  Data? data;

  MarkreadNotificationModel({this.status, this.data});

  MarkreadNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? type;
  String? status;
  Advertise? advertise; // ✅ Fixed: was `Null advertise` — now a proper nullable class
  Order? order;

  Data({this.id, this.type, this.status, this.advertise, this.order});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    status = json['status'];
    // ✅ Fixed: parse advertise as Advertise object if present, null otherwise
    advertise = json['advertise'] != null ? Advertise.fromJson(json['advertise']) : null;
    // ✅ Fixed: API returns key "order" (not "order_controller") when order is present
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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

// ✅ New class matching API response:
// "advertise": {"title":"14","url":"https://www.dndj.com","socialmedia":"instagram"}
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
    return {
      'title': title,
      'url': url,
      'socialmedia': socialmedia,
    };
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
    return {
      'customer_name': customerName,
      'email': email,
    };
  }
}