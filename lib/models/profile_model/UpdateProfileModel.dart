class UpdateProfileModel {
  bool? status;
  String? message;
  User? user;
  Profile? profile;

  UpdateProfileModel({this.status, this.message, this.user, this.profile});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['site_name'] = this.siteName;
    data['fav_icon'] = this.favIcon;
    data['logo_light'] = this.logoLight;
    data['logo_dark'] = this.logoDark;
    data['footer'] = this.footer;
    data['address'] = this.address;
    return data;
  }
}
