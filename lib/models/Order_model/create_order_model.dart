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
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['order_id'] = orderId;
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
    json['product'] != null ? Product.fromJson(json['product']) : null;
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    pricing =
    json['pricing'] != null ? Pricing.fromJson(json['pricing']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (pricing != null) {
      data['pricing'] = pricing!.toJson();
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
    name = json['name']?.toString();
    category = json['category']?.toString();
    image = (json['image'] ?? json['image_url'] ?? '').toString();
    weightInGram = json['weight_in_gram']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category'] = category;
    data['image'] = image;
    data['weight_in_gram'] = weightInGram;
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
    name = json['name']?.toString();
    phone = json['phone']?.toString();
    email = (json['email'] ?? json['customer_email'] ?? '').toString();
    address = json['address']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['selling_price_per_gram'] = sellingPricePerGram;
    data['quantity'] = quantity;
    data['sub_total'] = subTotal;
    data['shipping_cost'] = shippingCost;
    data['total_price'] = totalPrice;
    data['sold_price'] = soldPrice;
    return data;
  }
}
