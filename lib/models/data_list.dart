import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bbs_survey_app/utils/database_helpter.dart';
import 'package:bbs_survey_app/models/householdInfo.dart';

class DataList extends StatefulWidget {
  @override
  _DataListPageState createState() => new _DataListPageState();
}

//class DataList extends StatelessWidget {
class _DataListPageState extends State<DataList> {
  HouseHoldInfo _houseHoldInfo = HouseHoldInfo();
  List<HouseHoldInfo> _houseHoldInfoes = [];
  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
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
      appBar: AppBar(
          //title: Text("Second Route"),
          ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildCells(20),
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildRows(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRows() {
    return List.generate(
      _houseHoldInfoes.length,
      (index) => Row(
        children: _buildCells(6),
      ),
    );
  }

  //for (var itme in _houseHoldInfoes)

  List<Widget> _buildCells(int count) {
    return List.generate(
      count,
      (index) => Container(
          alignment: Alignment.center,
          width: 120.0,
          height: 60.0,
          color: Colors.white,
          margin: EdgeInsets.all(4.0),
          child: new ListView.builder(
              itemCount: _houseHoldInfoes.length,
              itemBuilder: (BuildContext ctxt, int Index) {
                return new Text(_houseHoldInfoes[Index].nameOfHead.toString());
              })),
    );
  }

  _refreshContactList() async {
    List<HouseHoldInfo> x = await _dbHelper.fetchHouseHoldInfo();
    setState(() {
      _houseHoldInfoes = x;
    });
  }

  _tableView() => Table(border: TableBorder.all(), children: [
        TableRow(children: [
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text("Household ID"),
                new Text("Name of Head"),
                new Text("Mobile Number"),
                new Text("National ID"),
                new Text("Number Of Male"),
                new Text("Number Of Female"),
              ],
            ),
          )
        ]),
        for (var itme in _houseHoldInfoes)
          TableRow(children: [
            TableCell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Text(itme.householdId.toString()),
                  new Text(itme.nameOfHead.toString()),
                  new Text(itme.mobileNumber.toString()),
                  new Text(itme.nationalId.toString()),
                  new Text(itme.numberOfMale.toString()),
                  new Text(itme.numberOfFemale.toString()),
                ],
              ),
            )
          ])
      ]);
}
