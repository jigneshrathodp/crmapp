class CreateOrderModel {
  bool? status;
  String? message;
  String? orderId;
  Data? data;

  CreateOrderModel({this.status, this.message, this.orderId, this.data});

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    orderId = json['order_id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['order_id'] = this.orderId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? orderId;
  Product? product;
  Customer? customer;
  Pricing? pricing;

  Data({this.orderId, this.product, this.customer, this.pricing});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    pricing =
    json['pricing'] != null ? new Pricing.fromJson(json['pricing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.pricing != null) {
      data['pricing'] = this.pricing!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? category;
  String? image;
  String? weightInGram;

  Product({this.id, this.name, this.category, this.image, this.weightInGram});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    image = json['image'];
    weightInGram = json['weight_in_gram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['image'] = this.image;
    data['weight_in_gram'] = this.weightInGram;
    return data;
  }
}

class Customer {
  String? name;
  String? phone;
  String? email;
  String? address;

  Customer({this.name, this.phone, this.email, this.address});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    return data;
  }
}

class Pricing {
  String? sellingPricePerGram;
  String? quantity;
  String? subTotal;
  String? shippingCost;
  String? totalPrice;
  String? soldPrice;

  Pricing(
      {this.sellingPricePerGram,
        this.quantity,
        this.subTotal,
        this.shippingCost,
        this.totalPrice,
        this.soldPrice});

  Pricing.fromJson(Map<String, dynamic> json) {
    sellingPricePerGram = json['selling_price_per_gram']?.toString();
    quantity = json['quantity']?.toString();
    subTotal = json['sub_total']?.toString();
    shippingCost = json['shipping_cost']?.toString();
    totalPrice = json['total_price']?.toString();
    soldPrice = json['sold_price']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selling_price_per_gram'] = this.sellingPricePerGram;
    data['quantity'] = this.quantity;
    data['sub_total'] = this.subTotal;
    data['shipping_cost'] = this.shippingCost;
    data['total_price'] = this.totalPrice;
    data['sold_price'] = this.soldPrice;
    return data;
  }
}
