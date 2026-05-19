class GetproductModel {
  bool? status;
  List<Data>? data;

  GetproductModel({this.status, this.data});

  GetproductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['sku'] = sku;
    data['quantity'] = quantity;
    data['sell_price'] = sellPrice;
    data['weight_in_gram'] = weightInGram;
    data['cost_per_gram'] = costPerGram;
    data['total_cost'] = totalCost;
    data['image'] = image;
    data['active'] = active;
    data['for_sale'] = forSale;
    return data;
  }
}
