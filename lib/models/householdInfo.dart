class HouseHoldInfo {
  static const tblHouseHoldInfo = 'HouseHoldInfo';
  static const colId = 'id';
  static const colHouseholdId = 'householdId';
  static const colNameOfHead = 'nameOfHead';
  static const colMobileNumber = 'mobileNumber';
  static const colNationalId = 'nationalId';
  static const colNumberOfMale = 'numberOfMale';
  static const colNumberOfFemale = 'numberOfFemale';

  HouseHoldInfo(
      {this.id,
      this.householdId,
      this.nameOfHead,
      this.mobileNumber,
      this.nationalId,
      this.numberOfMale,
      this.numberOfFemale});

  HouseHoldInfo.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    householdId = map[colHouseholdId];
    nameOfHead = map[colNameOfHead];
    mobileNumber = map[colMobileNumber];
    nationalId = map[colNationalId];
    numberOfMale = map[colNumberOfMale];
    numberOfFemale = map[colNumberOfFemale];
  }

  factory HouseHoldInfo.fromJson(Map<String, dynamic> json) {
    return HouseHoldInfo(
      //id: json['id'],
      householdId: json['householdId'],
      nameOfHead: json['nameOfHead'],
      mobileNumber: json['mobileNumber'],
      nationalId: json['nationalId'],
      numberOfMale: json['numberOfMale'],
      numberOfFemale: json['numberOfFemale'],
    );
  }

  int id;
  String householdId;
  String nameOfHead;
  String mobileNumber;
  String nationalId;
  int numberOfMale;
  int numberOfFemale;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colHouseholdId: householdId,
      colNameOfHead: nameOfHead,
      colMobileNumber: mobileNumber,
      colNationalId: nationalId,
      colNumberOfMale: numberOfMale,
      colNumberOfFemale: numberOfFemale
    };
    if (id != null) map[colId] = id;
    return map;
  }
}
/*
householdId, nameOfHead, mobileNumber, nationalId, numberOfMale, numberOfFemale*/
