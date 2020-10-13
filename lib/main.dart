import 'package:bbs_survey_app/login.dart';
import 'package:bbs_survey_app/models/householdInfo.dart';
import 'package:bbs_survey_app/utils/database_helpter.dart';
import 'package:flutter/material.dart';
import 'package:bbs_survey_app/models/householdInfo.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'horizontal_data_table.dart';

const darkBlueColor = Colors.red;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: darkBlueColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage()
        //MyHomePage(title: 'BBS Survey App'),
        );
  }
}
