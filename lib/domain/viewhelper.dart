import 'package:collection/src/list_extensions.dart';
import 'package:sectorworkingcondition/model/occupation.dart';
import 'package:sectorworkingcondition/model/coordinates.dart';
import 'package:sectorworkingcondition/model/wagerate.dart';

 class ViewHelper {
  static List<Occupation> GenerateOccupationList(List<WageRateResultSet> entityList)
  {

    int maxFinYear =0;
    Set<String> _ids = new Set<String>();
    List<Occupation> resultList = [];
    entityList.forEach((element) {
      if(element.finYear > maxFinYear)
        maxFinYear = element.finYear;
    });

    var output = entityList.where((element) => element.finYear == maxFinYear);

    output.toList().forEach((element) {
      if(!_ids.contains(element.occupation))
      {
        _ids.add(element.occupation);
        resultList.add(Occupation(
            id:1,
            title:element.occupation,
            grade:element.ordinal.toString(),
            amount:element.amount));
      }

    });

    resultList.sortBy((element) => element.title);

    return resultList.toList();
  }

  static List<Coordinates> GenerateFinYearList(List<WageRateResultSet> entityList)
  {

    Set<int> _ids = new Set<int>();
     List<Coordinates> resultList = [];

    entityList.toList().forEach((element) {
      if(!_ids.contains(element.finYear))
      {
        _ids.add(element.finYear);
        resultList.add(
            Coordinates(element.propertyValue, element.finYear,element.cpiIndex));
      }
      });

    resultList.sortBy((element) => element.series.toString());

    return resultList.toList();
  }
}