class GetProfileModel {
  bool? status;
  User? user;
  Details? details;

  GetProfileModel({this.status, this.user, this.details});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? contact;
  String? image;

  User({this.id, this.name, this.email, this.contact, this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['image'] = this.image;
    return data;
  }
}

class Details {
  String? siteName;
  String? favIcon;
  String? logoLight;
  String? logoDark;
  String? footer;
  String? address;

  Details(
      {this.siteName,
        this.favIcon,
        this.logoLight,
        this.logoDark,
        this.footer,
        this.address});

  Details.fromJson(Map<String, dynamic> json) {
    siteName = json['site_name'];
    favIcon = json['fav_icon'];
    logoLight = json['logo_light'];
    logoDark = json['logo_dark'];
    footer = json['footer'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['site_name'] = siteName;
    data['fav_icon'] = favIcon;
    data['logo_light'] = logoLight;
    data['logo_dark'] = logoDark;
    data['footer'] = footer;
    data['address'] = address;
    return data;
  }
}
