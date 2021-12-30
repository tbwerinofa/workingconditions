class Coordinates{
  double category;
  int series;

  Coordinates(this.category,this.series);

  Coordinates.fromObject(dynamic o){
    this.category =o["x"];
    this.series =o["y"];
    }

}
