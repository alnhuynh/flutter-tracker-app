import 'package:hive_flutter/hive_flutter.dart';
import '../datetime/date_time.dart';

// object from main.dart
final _myBox = Hive.box("Tracker_DB");

class TrackerDB {
  List taskList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // first time users
  void createDefaultData() {
    taskList = [
      ["Your habit here", false],
      ["Drink water", false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  void loadData() {
    // if it's a new day, get habit list from database
    if (_myBox.get(todaysDateFormatted()) == null) {
      taskList = _myBox.get("CURRENT_TASK_LIST");
      // set all habit completed to false since it's a new day
      for (int i = 0; i < taskList.length; i++) {
        taskList[i][1] = false;
      }
    }
    // if it's not a new day, load todays list
    else {
      taskList = _myBox.get(todaysDateFormatted());
    }
  }

  // update database
  void updateDatabase() {
    // update todays entry
    _myBox.put(todaysDateFormatted(), taskList);

    // update universal habit list in case it changed (new habit, edit habit, delete habit)
    _myBox.put("CURRENT_TASK_LIST", taskList);

    // data display
    calculateHabitPercentages();
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int count = 0;
    for(int i = 0; i < taskList.length; i++) {
      if(taskList[i][1] == true) {
        count++;
      }
    }

    String percent = taskList.isEmpty ? '0.0'
    : (count / taskList.length).toStringAsFixed(1);

    // key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // value: string of 1dp number between 0.0-1.0 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      // print(heatMapDataSet);
    }
  }

}