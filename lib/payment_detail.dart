import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sewa_dong_project/Model/ordered_items.dart';
import 'package:sewa_dong_project/Utils/DefaultSpecification.dart';
import 'package:sewa_dong_project/Utils/SessionUser.dart';
import 'dart:async';
import 'package:sewa_dong_project/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDetail extends StatefulWidget {
  final String paymentType;
  final OrderedItems orderedItems;

  PaymentDetail({this.paymentType, this.orderedItems});

  @override
  State<StatefulWidget> createState() {
    return PaymentDetailState();
  }
}

class PaymentDetailState extends State<PaymentDetail>
    with SingleTickerProviderStateMixin {
  int _totalPrice = 0;
  DateTime _rundownTime;
  Timer _timer;

  @override
  void initState() {
    var now = DateTime.now();
    _rundownTime = DateTime(now.year, now.month, now.day, 3, 0, 0, 0, 0);
    widget.orderedItems.end.difference(widget.orderedItems.start).inDays == 0
        ? _totalPrice = widget.orderedItems.vehicle.price
        : _totalPrice = widget.orderedItems.end
                .difference(widget.orderedItems.start)
                .inDays *
            widget.orderedItems.vehicle.price;
    _timer = Timer.periodic(
        Duration(minutes: 1),
        (_) => setState(
            () => _rundownTime = _rundownTime.add(Duration(minutes: -1))));

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Card(
          elevation: 8.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: 0,
                fit: FlexFit.tight,
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Pembayaran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 0,
                child: Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Text('Pembayaran dilakukan melalui: ',
                                    style: TextStyle(fontSize: 15))),
                            Text(widget.paymentType,
                                style: TextStyle(fontSize: 15))
                          ],
                        )
                      ],
                    )),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 0,
                child: Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Text('Nama:',
                                    style: TextStyle(fontSize: 15))),
                            Text(SessionUser.user.nama,
                                style: TextStyle(fontSize: 15))
                          ],
                        )
                      ],
                    )),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 0,
                child: Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Text('No rek:',
                                    style: TextStyle(fontSize: 15))),
                            Text('09375849374783',
                                style: TextStyle(fontSize: 15))
                          ],
                        )
                      ],
                    )),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 0,
                child: Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Text('Total harga: ',
                                  style: TextStyle(fontSize: 15)),
                              flex: 1,
                            ),
                            Text('$_totalPrice', style: TextStyle(fontSize: 15))
                          ],
                        )
                      ],
                    )),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    alignment: Alignment.center,
                    child: Text(
                        'Bayar sebelum: ${DateFormat("hh:mm").format(_rundownTime)}',
                        style: TextStyle(fontSize: 15))),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                alignment: Alignment.center,
                child: RaisedButton(
                  color: Colors.lightBlue,
                  child: Text('Sudah Bayar'),
                  onPressed: () async {
                    await _setOrderedItemsToPreference();
                    await Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                message:
                                    'Payment success for ${widget.orderedItems.vehicle.nama}')),
                        (Route<dynamic> route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setOrderedItemsToPreference() async {
    await SharedPreferences.getInstance().then((pref) async {
      if (pref.containsKey('history')) {
        List<String> history = pref.getStringList('history');
        history.add('''{
          \"vehicle\":{
            \"nama\": \"${widget.orderedItems.vehicle.nama}\",
            \"brand\": \"${widget.orderedItems.vehicle.brand}\",
            \"image_path\": \"${widget.orderedItems.vehicle.imagePath}\",
            \"price\": ${widget.orderedItems.vehicle.price},
            \"provider\": \"${widget.orderedItems.vehicle.provider}\",
            \"supir\": \"${widget.orderedItems.vehicle.supir}\",
            \"type\": \"${widget.orderedItems.vehicle.type}\"
          },
          \"payment_type\": \"${widget.paymentType}\",
          \"start\": \"${DefaultSpecification.dateFormat(widget.orderedItems.start)}\",
          \"end\": \"${DefaultSpecification.dateFormat(widget.orderedItems.end)}\"
          }''');
        await pref.setStringList('history', history);
      } else {
        await pref.setStringList('history', [
          '''{
          \"vehicle\":{
            \"nama\": \"${widget.orderedItems.vehicle.nama}\",
            \"brand\": \"${widget.orderedItems.vehicle.brand}\",
            \"image_path\": \"${widget.orderedItems.vehicle.imagePath}\",
            \"price\": ${widget.orderedItems.vehicle.price},
            \"provider\": \"${widget.orderedItems.vehicle.provider}\",
            \"supir\": \"${widget.orderedItems.vehicle.supir}\",
            \"type\": \"${widget.orderedItems.vehicle.type}\"
          },
          \"payment_type\": \"${widget.paymentType}\",
          \"start\": \"${DefaultSpecification.dateFormat(widget.orderedItems.start)}\",
          \"end\": \"${DefaultSpecification.dateFormat(widget.orderedItems.end)}\"
          }'''
        ]);
      }
      SessionUser.user.coin += (_totalPrice * 0.1).round();
    });
  }
}
