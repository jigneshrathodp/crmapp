// Model for GET /products/{id} — returns a single product object under "data"
class ViewProductModel {
  bool? status;
  Data? data;

  ViewProductModel({this.status, this.data});

  ViewProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['status'] = status;
    if (data != null) result['data'] = data!.toJson();
    return result;
  }
}

class Data {
  int? id;
  String? categoryId;
  String? name;
  String? sku;
  String? quantity;
  String? sellPrice;
  String? weightInGram;
  String? costPerGram;
  String? totalCost;
  String? image;
  int? active;
  int? forSale;

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
    categoryId = json['category_id']?.toString();
    name = json['name']?.toString();
    sku = json['sku']?.toString();
    quantity = json['quantity']?.toString();
    sellPrice = json['sell_price']?.toString();
    weightInGram = json['weight_in_gram']?.toString();
    costPerGram = json['cost_per_gram']?.toString();
    totalCost = json['total_cost']?.toString();
    image = json['image']?.toString();
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
