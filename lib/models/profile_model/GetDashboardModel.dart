class GetDashboardModel {
  bool? status;
  String? message;
  Data? data;

  GetDashboardModel({this.status, this.message, this.data});

  GetDashboardModel.fromJson(Map<String, dynamic> json) {
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
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['status'] = status;
    data['advertise'] = advertise;
    if (order != null) {
      data['order'] = order!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = customerName;
    data['email'] = email;
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
    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;
    profile =
    json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    if (json['notifications'] != null) {
      notifications = <NotificationData>[];
      json['notifications'].forEach((v) {
        notifications!.add(NotificationData.fromJson(v));
      });
    }
    details =
    json['details'] != null ? Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stats != null) {
      data['stats'] = stats!.toJson();
    }
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (notifications != null) {
      data['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
    }
    if (details != null) {
      data['details'] = details!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_categories'] = totalCategories;
    data['total_products'] = totalProducts;
    data['total_sold_products'] = totalSoldProducts;
    data['total_orders'] = totalOrders;
    data['current_month_orders'] = currentMonthOrders;
    data['total_product_cost'] = totalProductCost;
    data['total_sold_price'] = totalSoldPrice;
    data['total_advertisements'] = totalAdvertisements;
    data['total_advertise_price'] = totalAdvertisePrice;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['site_name'] = siteName;
    data['footer'] = footer;
    data['logo_dark'] = logoDark;
    data['logo_light'] = logoLight;
    data['fav_icon'] = favIcon;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    return data;
  }
}
