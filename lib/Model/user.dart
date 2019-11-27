class User {
  final String nama, noHp, email, password;

  User({this.nama, this.noHp, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nama: json['nama'],
        email: json['email'],
        noHp: json['noHp'],
        password: json['password']);
  }
}
