class UserModel {
  String? name;
  String? number;
  String? email;

  UserModel({this.name, this.number, this.email});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['number'] = number;
    data['email'] = email;
    return data;
  }
}
