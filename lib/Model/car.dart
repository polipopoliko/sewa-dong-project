class Vehicle {
  final String nama, type, provider, brand, imagePath;
  final bool supir;
  final int price;

  Vehicle({this.nama, this.type, this.provider, this.brand, this.supir, this.price, this.imagePath});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      brand: json['brand'],
      imagePath: json['image_path'],
      nama: json['nama'],
      price: json['price'],
      provider: json['provider'],
      supir: json['supir'] == 'true' ? true : false,
      type: json['type']
    );
  }
}