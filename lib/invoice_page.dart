import 'package:flutter/material.dart';
import 'package:sewa_dong_project/Model/ordered_items.dart';
import 'package:sewa_dong_project/Utils/DefaultSpecification.dart';
import 'package:sewa_dong_project/Utils/SessionUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class InvoicePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InvoicePageState();
  }
}

class InvoicePageState extends State<InvoicePage> {
  List<OrderedItems> _orderedItemsList = [];
  bool isFetching = true;

  @override
  void initState() {
    SharedPreferences.getInstance().then((pref) {
      if (pref.containsKey('history')) {
        print(pref.getStringList('history'));
        _orderedItemsList = pref
            .getStringList('history')
            .map((i) => OrderedItems.fromJson(json.decode(i)))
            .toList();
      }
      setState(() => isFetching = false);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: isFetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _orderedItemsList.length > 0
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(_orderedItemsList.elementAt(index).vehicle.nama),
                      subtitle: Text(
                          '${DefaultSpecification.dateFormat(_orderedItemsList.elementAt(index).start)}-${DefaultSpecification.dateFormat(_orderedItemsList.elementAt(index).end)}'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvoiceDetailPage(
                                      id: index + 1,
                                      orderedItems:
                                          _orderedItemsList.elementAt(index),
                                    )));
                      },
                    );
                  },
                  itemCount: _orderedItemsList?.length ?? 0,
                )
              : Center(
                  child: Text('Belum ada transaksi'),
                ),
    );
  }
}

class InvoiceDetailPage extends StatelessWidget {
  final int id;
  final OrderedItems orderedItems;

  InvoiceDetailPage({this.id, this.orderedItems});

  @override
  Widget build(BuildContext context) {
    int totalPrice = 0;
    totalPrice = orderedItems.vehicle.price *
        (orderedItems.end.difference(orderedItems.start).inDays == 0
            ? 1
            : orderedItems.end.difference(orderedItems.start).inDays);
    return Material(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: 0,
                fit: FlexFit.tight,
                child: Text(
                  'Invoice',
                  style: TextStyle(fontSize: 45),
                ),
              ),
              Flexible(
                flex: 0,
                fit: FlexFit.tight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 0,
                      fit: FlexFit.tight,
                      child: Text(
                        'Kode Pelanggan : ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      fit: FlexFit.tight,
                      child: Text('P0001'),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 0,
                fit: FlexFit.tight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 0,
                      fit: FlexFit.tight,
                      child: Text(
                        'Nama Pelanggan : ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(SessionUser.user.nama)
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: Text(
                      'No Transaksi : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: Text('TR0000$id'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: Text(
                      'No Invoice : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: Text('SD 200157'),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Flexible(
                          flex: 0,
                          fit: FlexFit.tight,
                          child: Text(
                            'Tgl Invoice : ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          flex: 0,
                          fit: FlexFit.tight,
                          child: Text(DefaultSpecification.dateFormat(
                              orderedItems.start.add(Duration(days: -1)))),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Flexible(
                  fit: FlexFit.tight,
                  flex: 0,
                  child: Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text('Jenis Mobil'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('Tanggal Sewa'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('Tanggal Kembali'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('Denda'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('Harga Sewa'),
                          ),
                        ],
                      ))),
              Flexible(
                  fit: FlexFit.tight,
                  flex: 0,
                  child: Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                                '${orderedItems.vehicle.nama}\n(${orderedItems.vehicle.type})'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                                '${DefaultSpecification.dateFormat(orderedItems.start)}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                                '${DefaultSpecification.dateFormat(orderedItems.end)}'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('-'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('Rp. $totalPrice'),
                          ),
                        ],
                      ))),
              Flexible(
                flex: 0,
                fit: FlexFit.tight,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text('Total'),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(''),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(''),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(''),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('Rp. $totalPrice'),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Bank Transfer',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    '${orderedItems.paymentType}',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'An : ${SessionUser.user.nama}',
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 0,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'No Rek : 6044025352',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
