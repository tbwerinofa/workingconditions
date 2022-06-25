class Occupation{
  int id;
  int finYear;
  String title;
  String grade;
  double amount;

  Occupation({this.id,this.finYear,this.title,this.grade,this.amount});
  Map<String,dynamic> toMap(){
    return {'id':id,'finYear':finYear,'title':title,'grade':grade,'amount':amount};
  }
}