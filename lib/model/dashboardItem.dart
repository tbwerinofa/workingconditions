class DashBoardItem {
  int _id;
  int _finYear;
  String _group;
  int _groupId;
  String _name;
  int _ordinal;
  int _count;
  String _type;
  String _status;
  double _score;
  String _dateTimeStamp;
  String _message;
  String _url;
  String _icon;
  String _finYearMonth;
  int _X;
  int _Y;
  double _amount;
  double _amountGroup;
  double _balance;
  String _dateTimeStampString;
  String _amountString;
  String _description;
  int _siteBalance;

  DashBoardItem(this._finYear,this._group,this._groupId,this._name,this._ordinal,this._count,this._type,this._status,this._score,this._dateTimeStamp,this._message,this._url,this._icon,this._finYearMonth,this._X,this._Y,this._amount,this._amountGroup,this._balance,this._dateTimeStampString,this._amountString,this._description,this._siteBalance);
  DashBoardItem.WithId(this._id,this._finYear,this._group,this._groupId,this._name,this._ordinal,this._count,this._type,this._status,this._score,this._dateTimeStamp,this._message,this._url,this._icon,this._finYearMonth,this._X,this._Y,this._amount,this._amountGroup,this._balance,this._dateTimeStampString,this._amountString,this._description,this._siteBalance);

  int get  id => _id;
  int get finYear =>_finYear;
  String get group =>_group;
  int get groupId =>_groupId;
  String get name =>_name;
  int get ordinal =>_ordinal;
  int get count =>_count;
  String get type =>_type;
  String get status =>_status;
  double get score =>_score;
  String get dateTimeStamp =>_dateTimeStamp;
  String get message =>_message;
  String get url =>_url;
  String get icon =>_icon;
  String get finYearMonth =>_finYearMonth;
  int get X =>_X;
  int get Y =>_Y;
  double get amount =>_amount;
  double get amountGroup =>_amountGroup;
  double get balance =>_balance;
  String get dateTimeStampString =>_dateTimeStampString;
  String get amountString =>_amountString;
  String get description =>_description;
  int get siteBalance =>_siteBalance;
  //List<ChildDashboard> get childList =>_childList ;

  set finYear(int record) {
    _finYear = record;
  }
  set group(String record) {
    _group = record;
  }
  set groupId(int record) {
    _groupId = record;
  }
  set name(String record) {
    _name = record;
  }
  set ordinal(int record)  {_ordinal = record;}
  set count(int record)
  {
    _count = record;
  }
  set type(String record)
  {
    _type = record;
  }
  set status(String record)
  {
    _status = record;
  }
  set score(double record)
  {
    _score = record;
  }
  set dateTimeStamp(String record)
  {
    _dateTimeStamp = record;
  }
  set message(String record)
  {
    _message = record;
  }
  set url(String record)
  {
    _url = record;
  }
  set icon(String record)
  {
    _icon = record;
  }
  set finYearMonth(String record)
  {
    _finYearMonth = record;
  }

  set X(int record)
  {
  _X = record;
  }
  set Y(int record)
  {
    _Y = record;
  }
  set amount(double record)
  {
    _amount = record;
  }
  set amountGroup(double record)
  {
    _amountGroup = record;
  }
  set balance(double record)
  {
    _balance = record;
  }
  set dateTimeStampString(String record)
  {
    _dateTimeStampString = record;
  }
  set amountString(String record)
  {
    _amountString = record;
  }
  set description(String record)
  {
    _description = record;
  }
  set siteBalance(int record)
  {
    _siteBalance = record;
  }

  DashBoardItem.fromObject(dynamic o){
    this._id =o["Id"];
    this._finYear =o["FinYear"];
    this._group =o["Group"];
    this._groupId =o["GroupId"];
    this._name =o["Name"];
    this._ordinal =o["Ordinal"];
    this._count =o["Count"];
    this._type =o["Type"];
    this._status =o["Status"];
    this._score =o["Score"];
    this._dateTimeStamp =o["DateTimeStamp"];
    this._message =o["Message"];
    this._url =o["Url"];
    this._icon =o["Icon"];
    this._finYearMonth =o["FinYearMonth"];
    this._X =o["X"];
    this._Y =o["Y"];
    this._amount=o["Amount"];
    this._amountGroup=o["AmountGroup"];
    this._balance=o["Balance"];
    this._dateTimeStampString =o["DateTimeStampString"];
    this._amountString =o["AmountString"];
    this._description =o["Description"];
    this._siteBalance =o["SiteBalance"];
  }

  Map<String,dynamic> toMap(){
    return {'id':id,'title':_name};
  }
}
