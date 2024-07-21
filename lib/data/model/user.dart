class User {
  String? sId;
  String? name;
  String? email;
  String? password;
  int? role;
  List<dynamic>? wishlist;
  List<dynamic>? addresses;
  String? createdAt;
  String? updatedAt;

  User({
    this.sId,
    this.name,
    this.email,
    this.password,
    this.role,
    this.wishlist,
    this.addresses,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    wishlist = json['wishlist'] != null ? List<dynamic>.from(json['wishlist']) : null;
    addresses = json['addresses'] != null ? List<dynamic>.from(json['addresses']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    if (wishlist != null) {
      data['wishlist'] = wishlist;
    }
    if (addresses != null) {
      data['addresses'] = addresses;
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
