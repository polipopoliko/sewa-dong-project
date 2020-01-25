import 'package:sewa_dong_project/Model/car.dart';

class OrderedItems {
  final Vehicle vehicle;
  final DateTime start, end;
  final String paymentType;

  OrderedItems({this.vehicle, this.start, this.end, this.paymentType});

  factory OrderedItems.fromJson(Map<String, dynamic> json) {
    var splitStart =
        (json['start']).toString().split('-').map((i) => int.parse(i)).toList();
    var splitEnd =
        (json['end']).toString().split('-').map((i) => int.parse(i)).toList();
    var now = DateTime.now();

    return OrderedItems(
        end: DateTime(splitEnd[2], splitEnd[1], splitEnd[0], now.hour,
            now.minute, 0, 0, 0),
        start: DateTime(splitStart[2], splitStart[1], splitStart[0], now.hour,
            now.minute, 0, 0, 0),
        vehicle: Vehicle.fromJson(json['vehicle']),
        paymentType: json['payment_type']);
  }
}
