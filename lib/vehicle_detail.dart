import 'package:flutter/material.dart';
import 'package:sewa_dong_project/Model/car.dart';
import 'package:sewa_dong_project/Model/ordered_items.dart';
import 'package:sewa_dong_project/Utils/DefaultSpecification.dart';
import 'package:sewa_dong_project/payment_page.dart';

class VehicleDetailPage extends StatefulWidget {
  final Vehicle vec;

  VehicleDetailPage(this.vec);

  @override
  State<StatefulWidget> createState() {
    return VehicleDetailPageState();
  }
}

class VehicleDetailPageState extends State<VehicleDetailPage> {
  bool _isChecked;

  @override
  void initState() {
    _isChecked = widget.vec.supir;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              color: Colors.blue,
              alignment: Alignment.centerLeft,
              child: Text(
                'Info Mobil',
                style: TextStyle(fontSize: 32),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      widget.vec.imagePath,
                      width: 250,
                      height: 250,
                    ),
                    Text(widget.vec.provider,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(widget.vec.type,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(widget.vec.nama,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                )),
            widget.vec.supir
                ? Row(
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (val) =>
                            setState(() => _isChecked = !_isChecked),
                      ),
                      Text('Supir')
                    ],
                  )
                : Container(),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    'Harga',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Rp.${widget.vec.price}.00/Hari',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: Colors.blue,
              child: Text('Order'),
              onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => OrderDialog(widget.vec)),
            )
          ],
        ),
      ),
    );
  }
}

class OrderDialog extends StatefulWidget {
  final Vehicle vec;

  OrderDialog(this.vec);

  @override
  State<StatefulWidget> createState() {
    return OrderDialogState();
  }
}

class OrderDialogState extends State<OrderDialog> {
  TextEditingController _pickUpController, _returnController;
  DateTime _pickUp = DateTime.now(), _return = DateTime.now();
  bool _isChecked;

  @override
  void initState() {
    _isChecked = widget.vec.supir;
    _pickUpController = TextEditingController(
        text: '${DefaultSpecification.dateFormat(_pickUp)}');
    _returnController = TextEditingController(
        text: '${DefaultSpecification.dateFormat(_return)}');
    super.initState();
  }

  @override
  void dispose() {
    _returnController.dispose();
    _pickUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int diff = _return.difference(_pickUp).inDays;
    if (diff == 0) diff += 1;
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                child: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                color: Colors.blue,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Form Order',
                  style: TextStyle(fontSize: 32),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      widget.vec.imagePath,
                      width: 250,
                      height: 250,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(widget.vec.nama,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text(widget.vec.type,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text('Lokasi : Jakarta',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Text(
                'Tanggal Sewa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text('Penjemputan', style: TextStyle(fontSize: 18)),
                  )),
                  Expanded(
                      child: InkWell(
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: _pickUpController,
                            ),
                          ),
                          onTap: () async => showDatePicker(
                                firstDate: DateTime.now(),
                                initialDate: _pickUp,
                                lastDate: DateTime(9999),
                                context: context,
                              ).then((val) {
                                if (val != null)
                                  setState(() {
                                    _pickUp = val;
                                    _pickUpController.text =
                                        DefaultSpecification.dateFormat(val);
                                  });
                              })))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Pengembalian',
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
                  Expanded(
                      child: InkWell(
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: _returnController,
                            ),
                          ),
                          onTap: () async => showDatePicker(
                                firstDate: _pickUp,
                                initialDate: _return,
                                lastDate: DateTime(9999),
                                context: context,
                              ).then((val) {
                                if (val != null)
                                  setState(() {
                                    _return = val;
                                    _returnController.text =
                                        DefaultSpecification.dateFormat(val);
                                  });
                              })))
                ],
              ),
              widget.vec.supir
                  ? Row(
                      children: <Widget>[
                        Checkbox(
                          value: _isChecked,
                          onChanged: (val) => setState(() => _isChecked = val),
                        ),
                        Text('Supir')
                      ],
                    )
                  : Container(),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Harga : ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text('Rp.${diff * widget.vec.price}.00',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  )
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Colors.blue,
                    child: Text('Bayar'),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentPage(
                                  orderedItems: OrderedItems(
                                      vehicle: widget.vec,
                                      start: _pickUp,
                                      end: _return,),
                                )),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
