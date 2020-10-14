import 'package:bbs_survey_app/horizontal_data_table.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:bbs_survey_app/utils/database_helpter.dart';
import 'package:bbs_survey_app/models/householdInfo.dart';
import 'package:toast/toast.dart';

class HorizontalTable extends StatefulWidget {
  @override
  _HorizontalTableState createState() => _HorizontalTableState();
}

class _HorizontalTableState extends State<HorizontalTable> {
  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;

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
        backgroundColor: Colors.orange[900],
        title: Text("Household Information"),
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 120,
        rightHandSideColumnWidth: 750,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: _houseHoldInfoes.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      FlatButton(
        padding: EdgeInsets.all(0),
        child: _getTitleItemWidget(
            'Household No' +
                (sortType == sortName ? (isAscending ? '  ↓' : '  ↑') : ''),
            120,
            Colors.orange[600]),
        onPressed: () {
          // sortType = sortName;
          // isAscending = !isAscending;
          // user.sortName(isAscending);
          // setState(() {
          //
          // });
        },
      ),
      Container(
        width: 2,
        height: 56,
        color: Colors.white,
      ),
      _getTitleItemWidget(
        'Action',
        70,
        Colors.orange[700],
      ),
      Container(
        width: 2,
        height: 56,
        color: Colors.white,
      ),
      _getTitleItemWidget('Name', 150, Colors.orange[700]),
      Container(
        width: 2,
        height: 56,
        color: Colors.white,
      ),
      _getTitleItemWidget('Mobile', 100, Colors.orange[700]),
      Container(
        width: 2,
        height: 56,
        color: Colors.white,
      ),
      _getTitleItemWidget('NID', 150, Colors.orange[700]),
      Container(
        width: 2,
        height: 56,
        color: Colors.white,
      ),
      _getTitleItemWidget('No of Male', 100, Colors.orange[700]),
      Container(
        width: 2,
        height: 56,
        color: Colors.white,
      ),
      _getTitleItemWidget('No of Female', 100, Colors.orange[700]),
    ];
  }

  Widget _getTitleItemWidget(String label, double width, color) {
    return Container(
      color: color,
      child: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      color: Colors.orange[600],
      child: Text(
        _houseHoldInfoes[index].householdId,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      width: 120,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await _dbHelper.deleteHouseHoldInfo(_houseHoldInfoes[index].id);
              Toast.show("Delete Successfully", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              _refreshContactList();
            },
          ),
          width: 70,
          height: 50,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.center,
        ),
        Container(
          width: 2,
          height: 52,
          color: Colors.blueGrey,
        ),
        Container(
          child: Text(
            _houseHoldInfoes[index].nameOfHead,
            style: TextStyle(fontSize: 12),
          ),
          width: 150,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          width: 2,
          height: 52,
          color: Colors.blueGrey,
        ),
        Container(
          child: Text(
            _houseHoldInfoes[index].mobileNumber,
            style: TextStyle(fontSize: 12),
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          width: 2,
          height: 56,
          color: Colors.blueGrey,
        ),
        Container(
          child: Text(
            _houseHoldInfoes[index].nationalId,
            style: TextStyle(fontSize: 12),
          ),
          width: 150,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          width: 2,
          height: 56,
          color: Colors.blueGrey,
        ),
        Container(
          child: Text(
            _houseHoldInfoes[index].numberOfMale.toString(),
            style: TextStyle(fontSize: 12),
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          width: 2,
          height: 56,
          color: Colors.blueGrey,
        ),
        Container(
          child: Text(
            _houseHoldInfoes[index].numberOfFemale.toString(),
            style: TextStyle(fontSize: 12),
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          width: 2,
          height: 56,
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  _refreshContactList() async {
    List<HouseHoldInfo> x = await _dbHelper.fetchHouseHoldInfo();
    setState(() {
      _houseHoldInfoes = x;
    });
  }
}
