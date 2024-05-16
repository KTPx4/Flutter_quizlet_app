class AccountModel {
  String id;
  String fullName;
  String user;
  String passWord;
  String email;
  String phone;
  String nameAvt;

  AccountModel(
      {this.id = "",
      required this.fullName,
      required this.user,
      required this.passWord,
      required this.email,
      required this.phone,
      required this.nameAvt});
  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['_id'] ?? "",
      fullName: json['fullName'] ?? "",
      user: json['user'] ?? "",
      passWord: json['passWord'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      nameAvt: json['nameAvt'] ?? "",
    );
  }
}
