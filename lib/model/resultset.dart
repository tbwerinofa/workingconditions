class ResultSet{
  String name;
  int id;

  ResultSet(this.name,this.id);

  ResultSet.fromObject(dynamic o){
    this.name =o["name"];
    this.id =o["id"];
    }

}
