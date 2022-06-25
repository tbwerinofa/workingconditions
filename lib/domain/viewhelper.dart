import 'package:collection/src/list_extensions.dart';
import 'package:cbatracker/model/occupation.dart';
import 'package:cbatracker/model/coordinates.dart';
import 'package:cbatracker/model/wagerate.dart';

 class ViewHelper {

   static List<String> GenerateOccupationGroupList(
       List<Map<String, dynamic>> dbList) {
     var entityList = dbList.map((model) =>
         WageRateResultSet.fromDatabase(model)).toList();
     int maxFinYear = 0;
     Set<String> resultSet = new Set<String>();
     entityList.forEach((element) {
       if (element.finYear > maxFinYear)
         maxFinYear = element.finYear;
     });

     var output = entityList.where((element) => element.finYear == maxFinYear);

     output.toList().forEach((element) {
       if (!resultSet.contains(element.occupationGroup)) {
         resultSet.add(element.occupationGroup);
         print(element.occupationGroup);
       }
     });

     resultSet.toList().sortBy((element) => element);

     return resultSet.toList();
   }

   static List<Occupation> GenerateOccupationList(
       List<WageRateResultSet> entityList, String occupationGroup) {
     int maxFinYear = 0;
     Set<String> _ids = new Set<String>();
     List<Occupation> resultList = [];
     entityList.forEach((element) {
       if (element.finYear > maxFinYear)
         maxFinYear = element.finYear;
     });

     var output = occupationGroup == null
         ? entityList.where((element) => element.finYear == maxFinYear)
         : entityList.where((element) =>
     element.finYear == maxFinYear &&
         element.occupationGroup == occupationGroup);

     output.toList().forEach((element) {
       if (!_ids.contains(element.occupation)) {
         _ids.add(element.occupation);
         resultList.add(Occupation(
             id: 1,
             title: element.occupation,
             grade: element.ordinal.toString(),
             finYear: element.finYear,
             amount: element.amount));
       }
     });

     resultList.sortBy((element) => element.title);

     return resultList.toList();
   }

   static Occupation GetOccupation(List<Map<String, dynamic>> dbList,
       String occupation)
   {
     var entityList = dbList.map((model) =>
         WageRateResultSet.fromDatabase(model)).toList();

     int maxFinYear = 0;
     Set<String> _ids = new Set<String>();

     entityList.forEach((element) {
       if (element.finYear > maxFinYear)
         maxFinYear = element.finYear;
     });

     var result = entityList.firstWhere((element) =>
     element.finYear == maxFinYear &&
         element.occupation == occupation);

         Occupation record = new Occupation(
             id: 1,
             title: result.occupation,
             grade: result.ordinal.toString(),
             finYear: result.finYear,
             amount: result.amount);
      return record;
   }

   static List<String> GetOccupationList(List<Map<String, dynamic>> dbList,
       String occupationGroup)
   {
     var entityList = dbList.map((model) =>
         WageRateResultSet.fromDatabase(model)).toList();

     var resultSet = GenerateOccupationList(entityList,occupationGroup);
      return resultSet
           .map((item) => item.title)
           .toList();
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
            Coordinates(element.amount, element.finYear,element.cpiIndex));
      }
      });

    resultList.sortBy((element) => element.series.toString());

    return resultList.toList();
  }
}