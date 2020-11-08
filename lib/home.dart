import 'dart:async';
import 'dart:io';

import 'package:bbs_survey_app/login.dart';
import 'package:bbs_survey_app/models/householdInfo.dart';
import 'package:bbs_survey_app/utils/database_helpter.dart';
import 'package:flutter/material.dart';
import 'package:bbs_survey_app/models/householdInfo.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'animation/fade_animation.dart';
import 'horizontal_data_table.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

List<HouseHoldInfo> _houseHoldInfoes = [];
HouseHoldInfo _houseHoldInfo = HouseHoldInfo();
DatabaseHelper _dbHelper;
final _formkey = GlobalKey<FormState>();
final _ctrHouseHoldId = TextEditingController();
final _ctrName = TextEditingController();
final _ctrMobile = TextEditingController();
final _ctrNID = TextEditingController();
final _ctrMaleNo = TextEditingController();
final _ctrFemaleNo = TextEditingController();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  Future<void> _onItemTapped(int index) async {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HorizontalTable()),
      );
    } else if (index == 1) {
      _refreshContactList();

      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (_houseHoldInfoes.length > 0) {
            for (var item in _houseHoldInfoes) {
              _dbHelper.addHouseHoldInfo(item);
              Toast.show("Household infoes sync Successfully", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              _dbHelper.deleteHouseHoldInfo(item.id);
            }
          } else {
            Toast.show("No Data Available", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        }
      } on SocketException catch (_) {
        Toast.show("Internet Not Available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      bottomNavigationBar: _bottom(),
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
          child: Text(
            "BBS Survey APP",
            style: TextStyle(color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: _form(),
        //child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // _list()
  _form() => Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _ctrHouseHoldId,
                decoration: InputDecoration(labelText: 'Household ID'),
                onSaved: (val) =>
                    setState(() => _houseHoldInfo.householdId = val),
                validator: (val) =>
                    (val.length == 0 ? "This filed is required" : null),
              ),
              TextFormField(
                controller: _ctrName,
                decoration: InputDecoration(labelText: 'name of head'),
                onSaved: (val) =>
                    setState(() => _houseHoldInfo.nameOfHead = val),
                validator: (val) =>
                    (val.length == 0 ? "This filed is required" : null),
              ),
              TextFormField(
                controller: _ctrMobile,
                decoration: InputDecoration(labelText: 'mobile number'),
                onSaved: (val) =>
                    setState(() => _houseHoldInfo.mobileNumber = val),
                validator: (val) =>
                    (val.length == 0 ? "This filed is required" : null),
              ),
              TextFormField(
                controller: _ctrNID,
                decoration: InputDecoration(labelText: 'national ID'),
                onSaved: (val) =>
                    setState(() => _houseHoldInfo.nationalId = val),
                validator: (val) =>
                    (val.length == 0 ? "This filed is required" : null),
              ),
              TextFormField(
                controller: _ctrMaleNo,
                decoration: InputDecoration(labelText: 'number of male'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSaved: (val) => setState(
                    () => _houseHoldInfo.numberOfMale = int.parse(val)),
                validator: (val) =>
                    (val.length == 0 ? "This filed is required" : null),
              ),
              TextFormField(
                controller: _ctrFemaleNo,
                decoration: InputDecoration(labelText: 'number of female'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSaved: (val) => setState(
                    () => _houseHoldInfo.numberOfFemale = int.parse(val)),
                validator: (val) =>
                    (val.length == 0 ? "This filed is required" : null),
              ),
              SizedBox(
                height: 20,
              ),
              FadeAnimation(
                  1.6,
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.orange[900]),
                    child: Center(
                      child: FlatButton(
                        onPressed: () => _onSubmit(),
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )),
            ],
          )));

  _onSubmit() async {
    var form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      if (_houseHoldInfo.id == null) {
        await _dbHelper.insertHouseHoldInfo(_houseHoldInfo);
        showAlertDialog(context, "Information Added Successfully");
      } else
        await _dbHelper.updateHouseHoldInfo(_houseHoldInfo);
      // setState(() {
      //   _contactList.add(Contact(id:null,name: _contact.name,mobile: _contact.mobile));
      // });
      _resetForm();
    }
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Success!"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _resetForm() {
    _formkey.currentState.reset();
    _ctrName.clear();
    _ctrMobile.clear();
    _ctrNID.clear();
    _ctrHouseHoldId.clear();
    _ctrFemaleNo.clear();
    _ctrMaleNo.clear();
    _houseHoldInfo.id = null;
  }

  _bottom() => ClipRRect(
        //borderRadius: BorderRadius.vertical(top:Radius.circular(40)),

        child: BottomNavigationBar(
          iconSize: 30,
          selectedIconTheme: IconThemeData(color: Colors.blue),
          unselectedIconTheme: IconThemeData(color: Colors.black12),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sync),
              label: 'Data Sync',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.data_usage),
              label: 'Data',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          backgroundColor: Colors.orange[800],
        ),
      );

  _refreshContactList() async {
    List<HouseHoldInfo> x = await _dbHelper.fetchHouseHoldInfo();
    setState(() {
      _houseHoldInfoes = x;
    });
  }
}
