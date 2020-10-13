import 'dart:io';
import 'package:bbs_survey_app/models/contact.dart';
import 'package:bbs_survey_app/models/householdInfo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "BbsSurveyData.db";
  static const _databaseVersion = 1;

  // static const _databaseNewVersion = 2;

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDb);
  }

  // , onUpgrade: _onUpgrade
  _onCreateDb(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${HouseHoldInfo.tblHouseHoldInfo}(
          ${HouseHoldInfo.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${HouseHoldInfo.colHouseholdId} TEXT NOT NULL,
          ${HouseHoldInfo.colNameOfHead} TEXT NOT NULL,          
          ${HouseHoldInfo.colMobileNumber} TEXT NOT NULL,
          ${HouseHoldInfo.colNationalId} TEXT NOT NULL,
          ${HouseHoldInfo.colNumberOfMale} INTEGER NOT NULL,
          ${HouseHoldInfo.colNumberOfFemale} INTEGER NOT NULL
          )    
    ''');

    await db.execute('''
          CREATE TABLE ${Contact.tblContact}(
          ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${Contact.colName} TEXT NOT NULL,
          ${Contact.colMobile} TEXT NOT NULL
          )    
    ''');
  }

  void _onUpgrade(
      Database db, int _databaseVersion, int _databaseNewVersion) async {
    // In this case, oldVersion is 1, newVersion is 2
    if (_databaseVersion == 1) {
      await db.execute('''
          CREATE TABLE ${HouseHoldInfo.tblHouseHoldInfo}(
          ${HouseHoldInfo.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${HouseHoldInfo.colHouseholdId} TEXT NOT NULL,
          ${HouseHoldInfo.colNameOfHead} TEXT NOT NULL,          
          ${HouseHoldInfo.colMobileNumber} TEXT NOT NULL,
          ${HouseHoldInfo.colNationalId} TEXT NOT NULL,
          ${HouseHoldInfo.colNumberOfMale} INTEGER NOT NULL,
          ${HouseHoldInfo.colNumberOfFemale} INTEGER NOT NULL,
          )    
    ''');
    }
  }

  Future<int> insertHouseHoldInfo(HouseHoldInfo houseHoldInfo) async {
    Database db = await database;
    return await db.insert(
        HouseHoldInfo.tblHouseHoldInfo, houseHoldInfo.toMap());
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(Contact.tblContact, contact.toMap());
  }

  Future<int> updateHouseHoldInfo(HouseHoldInfo houseHoldInfo) async {
    Database db = await database;
    return await db.update(
        HouseHoldInfo.tblHouseHoldInfo, houseHoldInfo.toMap(),
        where: '${HouseHoldInfo.colId}=?', whereArgs: [houseHoldInfo.id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await database;
    return await db.update(Contact.tblContact, contact.toMap(),
        where: '${Contact.colId}=?', whereArgs: [contact.id]);
  }

  Future<int> deleteHouseHoldInfo(int id) async {
    Database db = await database;
    return await db.delete(HouseHoldInfo.tblHouseHoldInfo,
        where: '${HouseHoldInfo.colId}=?', whereArgs: [id]);
  }

  Future<int> deleteContact(int id) async {
    Database db = await database;
    return await db.delete(Contact.tblContact,
        where: '${Contact.colId}=?', whereArgs: [id]);
  }

  Future<List<HouseHoldInfo>> fetchHouseHoldInfo() async {
    Database db = await database;
    List<Map> houseHoldInfoes = await db.query(HouseHoldInfo.tblHouseHoldInfo);
    return houseHoldInfoes.length == 0
        ? []
        : houseHoldInfoes.map((e) => HouseHoldInfo.fromMap(e)).toList();
  }

  Future<List<Contact>> fetchContatList() async {
    Database db = await database;
    List<Map> contacts = await db.query(Contact.tblContact);
    return contacts.length == 0
        ? []
        : contacts.map((e) => Contact.fromMap(e)).toList();
  }
}
