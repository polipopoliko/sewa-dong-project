import 'package:flutter/material.dart';
import 'package:sewa_dong_project/Model/ordered_items.dart';
import 'package:sewa_dong_project/payment_detail.dart';

class PaymentPage extends StatefulWidget {
  final OrderedItems orderedItems;

  PaymentPage({this.orderedItems});

  @override
  State<StatefulWidget> createState() {
    return PaymentPageState();
  }
}

class PaymentPageState extends State<PaymentPage> {
  List<String> _paymentTypeList = [];
  int _paymentType = 0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.blueGrey),
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.8,
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
                  decoration: BoxDecoration(border: Border.all()),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.blueGrey,
                        border:
                            Border(left: BorderSide(), right: BorderSide())),
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      itemBuilder: (context, index) => RadioListTile(
                            activeColor: Colors.black,
                            title: Text('${_paymentTypeList.elementAt(index)}'),
                            selected: _paymentType == index ? true : false,
                            onChanged: (val) =>
                                setState(() => _paymentType = val),
                            groupValue: _paymentType,
                            value: index,
                          ),
                      itemCount: _paymentTypeList?.length ?? 0,
                    )),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(),
                        right: BorderSide(),
                        bottom: BorderSide())),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.lightBlue,
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    RaisedButton(
                      color: Colors.lightBlue,
                      child: Text('Pay'),
                      onPressed: () async => await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentDetail(
                                  orderedItems: widget.orderedItems,
                                  paymentType: _paymentTypeList
                                      .elementAt(_paymentType)))),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _init() {
    _paymentTypeList.add('ATM BCA');
    _paymentTypeList.add('M-Banking BCA');
    _paymentTypeList.add('ATM Mandiri');
    _paymentTypeList.add('ATM BRI');
  }
}
