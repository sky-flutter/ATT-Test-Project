class LoginData {
  String id = "";
  String? name;
  String? email;

  LoginData({this.name, this.email});

  LoginData.fromJson(Map<String, dynamic> data) {
    this.id = data["id"];
    this.name = data["name"];
    this.email = data["email"];
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "email": email};
  }
}
