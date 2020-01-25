class User {
  final String nama, noHp, email, password;
  int coin;

  User({this.nama, this.noHp, this.email, this.password, this.coin = 0});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nama: json['nama'],
        email: json['email'],
        noHp: json['noHp'],
        password: json['password'],
        coin: json['coin'] != null ? int.parse(json['coin']) : 0);
  }
}
