class GetDashboardModel {
  bool? status;
  String? message;
  Data? data;

  GetDashboardModel({this.status, this.message, this.data});

  GetDashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NotificationData {
  dynamic id;
  String? type;
  String? status;
  dynamic advertise;
  Order? order;

  NotificationData({this.id, this.type, this.status, this.advertise, this.order});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    status = json['status'];
    advertise = json['advertise'];
    order = json['order_controller'] != null ? new Order.fromJson(json['order_controller']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['status'] = this.status;
    data['advertise'] = this.advertise;
    if (this.order != null) {
      data['order_controller'] = this.order!.toJson();
    }
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

class Data {
  Stats? stats;
  Profile? profile;
  List<NotificationData>? notifications;
  Details? details;

  Data({this.stats, this.profile, this.notifications, this.details});

  Data.fromJson(Map<String, dynamic> json) {
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    if (json['notifications'] != null) {
      notifications = <NotificationData>[];
      json['notifications'].forEach((v) {
        notifications!.add(new NotificationData.fromJson(v));
      });
    }
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stats != null) {
      data['stats'] = this.stats!.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Stats {
  dynamic totalCategories;
  dynamic totalProducts;
  dynamic totalSoldProducts;
  dynamic totalOrders;
  dynamic currentMonthOrders;
  dynamic totalProductCost;
  dynamic totalSoldPrice;
  dynamic totalAdvertisements;
  dynamic totalAdvertisePrice;

  Stats(
      {this.totalCategories,
        this.totalProducts,
        this.totalSoldProducts,
        this.totalOrders,
        this.currentMonthOrders,
        this.totalProductCost,
        this.totalSoldPrice,
        this.totalAdvertisements,
        this.totalAdvertisePrice});

  Stats.fromJson(Map<String, dynamic> json) {
    totalCategories = json['total_categories'];
    totalProducts = json['total_products'];
    totalSoldProducts = json['total_sold_products'];
    totalOrders = json['total_orders'];
    currentMonthOrders = json['current_month_orders'];
    totalProductCost = json['total_product_cost'];
    totalSoldPrice = json['total_sold_price'];
    totalAdvertisements = json['total_advertisements'];
    totalAdvertisePrice = json['total_advertise_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_categories'] = this.totalCategories;
    data['total_products'] = this.totalProducts;
    data['total_sold_products'] = this.totalSoldProducts;
    data['total_orders'] = this.totalOrders;
    data['current_month_orders'] = this.currentMonthOrders;
    data['total_product_cost'] = this.totalProductCost;
    data['total_sold_price'] = this.totalSoldPrice;
    data['total_advertisements'] = this.totalAdvertisements;
    data['total_advertise_price'] = this.totalAdvertisePrice;
    return data;
  }
}

class Profile {
  String? address;
  String? siteName;
  String? footer;
  String? logoDark;
  String? logoLight;
  String? favIcon;

  Profile(
      {this.address,
        this.siteName,
        this.footer,
        this.logoDark,
        this.logoLight,
        this.favIcon});

  Profile.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    siteName = json['site_name'];
    footer = json['footer'];
    logoDark = json['logo_dark'];
    logoLight = json['logo_light'];
    favIcon = json['fav_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['site_name'] = this.siteName;
    data['footer'] = this.footer;
    data['logo_dark'] = this.logoDark;
    data['logo_light'] = this.logoLight;
    data['fav_icon'] = this.favIcon;
    return data;
  }
}

class Details {
  dynamic id;
  String? name;
  String? email;
  String? image;

  Details({this.id, this.name, this.email, this.image});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;
    return data;
  }
}
