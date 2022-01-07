class Occupation{
  int id;
  String title;
  String grade;
  double amount;

  Occupation({this.id,this.title,this.grade,this.amount});
  Map<String,dynamic> toMap(){
    return {'id':id,'title':title,'grade':grade,'amount':amount};
  }
}