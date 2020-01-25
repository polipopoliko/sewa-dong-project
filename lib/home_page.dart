import 'package:flutter/material.dart';
import 'package:sewa_dong_project/Model/car.dart';
import 'package:sewa_dong_project/Utils/SessionUser.dart';
import 'package:sewa_dong_project/Utils/snackbar.dart';
import 'package:sewa_dong_project/invoice_page.dart';
import 'package:sewa_dong_project/vehicle_detail.dart';

class HomePage extends StatefulWidget {
  final String message;

  HomePage({this.message = ''});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _isHomePage = true, _isSorted = false;
  List<Vehicle> _vehicleList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print(widget.message);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.message.length > 0)
        Snackbar(scaffoldKey: _scaffoldKey, message: widget.message).showSnackbar();
    });
    _initializeVehicle();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sewa Dong'),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: Image.asset('images/account.png'),
              accountEmail: Text(SessionUser.user.nama),
              accountName: Text('Coins: ${SessionUser.user.coin}'),
            ),
            ListTile(
              title: Text('Status Order'),
              trailing: Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.pop(context);
                _featureNotAvailable();
              },
            ),
            ListTile(
              title: Text('History'),
              trailing: Icon(Icons.access_time),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => InvoicePage()
                ));
              },
            ),
            ListTile(
              title: Text('Rewards'),
              trailing: Icon(Icons.redeem),
              onTap: () {
                Navigator.pop(context);
                _featureNotAvailable();
              },
            ),
            ListTile(
              title: Text('Rental with me'),
              onTap: () {
                Navigator.pop(context);
                _featureNotAvailable();
              },
            ),
            ListTile(
              title: Text('Setting'),
              trailing: Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                _featureNotAvailable();
              },
            ),
            ListTile(
              title: Text('Help'),
              trailing: Icon(Icons.help),
              onTap: () {
                Navigator.pop(context);
                _featureNotAvailable();
              },
            ),
            ListTile(
              title: Text('FAQ'),
              trailing: Icon(Icons.live_help),
              onTap: () {
                Navigator.pop(context);
                _featureNotAvailable();
              },
            ),
            ListTile(
              trailing:
                  Icon(const IconData(59513, fontFamily: 'MaterialIcons')),
              title: Text('Logout'),
              onTap: () async {
                await SessionUser.clearSession().whenComplete(() async {
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                });
              },
            )
          ],
        ),
      ),
      body: _isHomePage
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 30),
                    child: Text(
                      'Butuh Kendaraan?\nSewa saja disini',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text('FILTER'),
                      onPressed: () => _isSorted = !_isSorted,
                    ),
                  ),
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _vehicleList?.length ?? 0,
                    itemBuilder: (context, index) {
                      var temp = _vehicleList.elementAt(index);
                      return Card(
                        child: ListTile(
                            leading: Image.asset(
                              temp.imagePath,
                              width: 150,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                            title: Text(temp.nama),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(temp.type),
                                Text(temp.brand),
                                Visibility(
                                    visible: temp.supir, child: Text('Supir')),
                                Text('Rp. ${temp.price}/hari')
                              ],
                            ),
                            trailing: Text(
                              temp.provider,
                              style: TextStyle(color: Colors.red),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VehicleDetailPage(temp)))),
                      );
                    },
                  )
                ],
              ),
            )
          : Center(child: Text('Notification Page')),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Icon(Icons.home),
              onPressed: () => setState(() => _isHomePage = true),
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Icon(Icons.notifications),
              onPressed: () => setState(() => _isHomePage = false),
            ),
          )
        ],
      ),
    );
  }

  void _initializeVehicle() {
    Vehicle vec = Vehicle(
        nama: 'Jazz',
        brand: 'Honda',
        price: 300000,
        provider: 'RTM Trans',
        supir: true,
        type: 'Matic',
        imagePath: 'images/jazz.jpg');
    _vehicleList.add(vec);
    vec = Vehicle(
        nama: 'Ayla',
        brand: 'Toyota',
        price: 200000,
        provider: 'Jelupang BSD',
        supir: true,
        type: 'Manual',
        imagePath: 'images/ayla.jpg');
    _vehicleList.add(vec);
    vec = Vehicle(
        nama: 'Terios',
        brand: 'Toyota',
        price: 500000,
        provider: 'Nanda',
        supir: true,
        type: 'Manual',
        imagePath: 'images/terios.jpg');
    _vehicleList.add(vec);
    vec = Vehicle(
        nama: 'City',
        brand: 'Honda',
        price: 350000,
        provider: 'Nando',
        supir: false,
        type: 'Matic',
        imagePath: 'images/city.jpg');
    _vehicleList.add(vec);
  }

  void _featureNotAvailable() => Snackbar(
          scaffoldKey: _scaffoldKey,
          durationInSeconds: 1,
          message: 'Fitur ini belum tersedia')
      .showSnackbar();
}
