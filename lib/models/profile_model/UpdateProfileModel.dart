class UpdateProfileModel {
  bool? status;
  String? message;
  User? user;
  Profile? profile;

  UpdateProfileModel({this.status, this.message, this.user, this.profile});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    profile =
    json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (profile != null) {
      data['profile'] = profile!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['contact'] = contact;
    data['image'] = image;
    return data;
  }
}

class Profile {
  String? siteName;
  String? favIcon;
  String? logoLight;
  String? logoDark;
  String? footer;
  String? address;

  Profile(
      {this.siteName,
        this.favIcon,
        this.logoLight,
        this.logoDark,
        this.footer,
        this.address});

  Profile.fromJson(Map<String, dynamic> json) {
    siteName = json['site_name'];
    favIcon = json['fav_icon'];
    logoLight = json['logo_light'];
    logoDark = json['logo_dark'];
    footer = json['footer'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['site_name'] = siteName;
    data['fav_icon'] = favIcon;
    data['logo_light'] = logoLight;
    data['logo_dark'] = logoDark;
    data['footer'] = footer;
    data['address'] = address;
    return data;
  }
}
