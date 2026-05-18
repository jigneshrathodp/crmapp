class GetproductModel {
  bool? status;
  List<Data>? data;

  GetproductModel({this.status, this.data});

  GetproductModel.fromJson(Map<String, dynamic> json) {
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
