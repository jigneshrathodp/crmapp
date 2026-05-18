class UpdateProductModel {
  bool? status;
  String? message;
  Data? data;

  UpdateProductModel({this.status, this.message, this.data});

  UpdateProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    // ✅ FIX: Handle both cases:
    //   - UPDATE response returns: "data": { ... }   → single object
    //   - GET list response returns: "data": [ {...} ] → array with one item
    if (json['data'] != null) {
      if (json['data'] is List) {
        // GET list API: take the first item from the array
        final list = json['data'] as List;
        data = list.isNotEmpty ? Data.fromJson(list[0]) : null;
      } else if (json['data'] is Map) {
        // UPDATE/CREATE API: single object
        data = Data.fromJson(json['data'] as Map<String, dynamic>);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['status'] = status;
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    return result;
  }
}

class Data {
  dynamic id;
  dynamic categoryId;
  dynamic name;
  dynamic sku;
  dynamic quantity;
  dynamic sellPrice;
  dynamic weightInGram;
  dynamic costPerGram;
  dynamic totalCost;
  dynamic image;
  dynamic active;
  dynamic forSale;

  Data({
    this.id,
    this.categoryId,
    this.name,
    this.sku,
    this.quantity,
    this.sellPrice,
    this.weightInGram,
    this.costPerGram,
    this.totalCost,
    this.image,
    this.active,
    this.forSale,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    sku = json['sku'];
    quantity = json['quantity'];
    sellPrice = json['sell_price'];
    weightInGram = json['weight_in_gram'];
    costPerGram = json['cost_per_gram'];
    totalCost = json['total_cost'];
    image = json['image'];
    active = json['active'];
    forSale = json['for_sale'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'sku': sku,
      'quantity': quantity,
      'sell_price': sellPrice,
      'weight_in_gram': weightInGram,
      'cost_per_gram': costPerGram,
      'total_cost': totalCost,
      'image': image,
      'active': active,
      'for_sale': forSale,
    };
  }
}