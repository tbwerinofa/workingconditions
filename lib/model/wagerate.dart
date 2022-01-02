
class WageRateResultSet {
  String gradingSystem;
  int finYear;
  String grade;
  int ordinal;
  String subSector;
  String occupation;
  String occupationGroup;
  int occupationGroupId;
  int finYearId;
  String employmentCondition;
  double amount;
  int occupationId;
  double propertyValue;
  double averagePropertyValue;
  bool isPrefix;
  String measurementUnit;
  String symbol;
  double cpiIndex;


  WageRateResultSet({
    this.gradingSystem,
    this.finYear,
    this.grade,
    this.ordinal,
    this.subSector,
    this.occupation,
    this.occupationGroup,
    this.occupationGroupId,
    this.finYearId,
    this.employmentCondition,
    this.amount,
    this.occupationId,
    this.propertyValue,
    this.averagePropertyValue,
    this.isPrefix,
    this.measurementUnit,
    this.symbol,
    this.cpiIndex,
  });

  factory WageRateResultSet.fromJson(Map<String, dynamic> json) {
    var model = new WageRateResultSet(
    gradingSystem: json['GradingSystem'],
    finYear: json['FinYear'],
    grade: json['Grade'],
    ordinal: json['Ordinal'],
    subSector: json['SubSector'],
    occupation: json['Occupation'],
    occupationGroup: json['OccupationGroup'],
    occupationGroupId: json['OccupationGroupId'],
    finYearId:json['FinYearId'],
    employmentCondition:json['EmploymentCondition'],
    amount:json['Amount'],
    occupationId:json['OccupationId'],
    propertyValue:json['PropertyValue'],
    averagePropertyValue:json['AveragePropertyValue'],
    isPrefix:json['IsPrefix'],
    measurementUnit:json['MeasurementUnit'],
    symbol:json['Symbol'],
    cpiIndex:json['CPIIndex'],

    );


    // var list = json['MilestoneRuleSet'] as List;
    //print(list.runtimeType); //returns List<dynamic>
    // List<MileStoneRule> imagesList = list.map((i) => MileStoneRule.fromJson(i)).toList();
    return model;
  }

  Map<String,dynamic> toMap(){
    return {
      'gradingSystem': gradingSystem,
      'finYear': finYear,
      'grade': grade,
      'ordinal': ordinal,
      'subSector': subSector,
      'occupation': occupation,
      'occupationGroup': occupationGroup,
      'occupationGroupId': occupationGroupId,
      'finYearId':finYearId,
      'employmentCondition':employmentCondition,
      'amount':amount,
      'occupationId':occupationId,
      'propertyValue':propertyValue,
      'averagePropertyValue':averagePropertyValue,
      'isPrefix':isPrefix,
      'measurementUnit':measurementUnit,
      'symbol':symbol,
      'cpiIndex':cpiIndex,
    };
  }

  factory WageRateResultSet.fromDatabase(Map<String, dynamic> json) {
    var model = new WageRateResultSet(
      gradingSystem: json['gradingSystem'],
      finYear: json['finYear'],
      grade: json['grade'],
      ordinal: json['ordinal'],
     // subSector: json['subSector'],
      occupation: json['occupation'],
      occupationGroup: json['occupationGroup'],
      occupationGroupId: json['occupationGroupId'],
     // finYearId:json['finYearId'],
     // employmentCondition:json['employmentCondition'],
      amount:json['amount'],
     // occupationId:json['occupationId'],
     propertyValue:json['propertyValue'],
     // averagePropertyValue:json['averagePropertyValue'],
      //isPrefix:json['isPrefix'],
      measurementUnit:json['measurementUnit'],
      symbol:json['symbol'],
      cpiIndex:json['cpiIndex'],

    );


    // var list = json['MilestoneRuleSet'] as List;
    //print(list.runtimeType); //returns List<dynamic>
    // List<MileStoneRule> imagesList = list.map((i) => MileStoneRule.fromJson(i)).toList();
    return model;
  }
}
