class Coordinates{
  double category;
  int series;
  double value;

  Coordinates(this.category,this.series,this.value);

  Coordinates.fromObject(dynamic o){
    this.category =o["x"];
    this.series =o["y"];
    }

}
