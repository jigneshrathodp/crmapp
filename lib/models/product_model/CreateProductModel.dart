class CreateProductModel {
  bool? status;
  String? message;
  Data? data;

  CreateProductModel({this.status, this.message, this.data});

  CreateProductModel.fromJson(Map<String, dynamic> json) {
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

  Data(
      {this.id,
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
        this.forSale});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['sku'] = this.sku;
    data['quantity'] = this.quantity;
    data['sell_price'] = this.sellPrice;
    data['weight_in_gram'] = this.weightInGram;
    data['cost_per_gram'] = this.costPerGram;
    data['total_cost'] = this.totalCost;
    data['image'] = this.image;
    data['active'] = this.active;
    data['for_sale'] = this.forSale;
    return data;
  }
}
