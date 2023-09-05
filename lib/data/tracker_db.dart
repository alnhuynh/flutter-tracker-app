import 'package:hive_flutter/hive_flutter.dart';

import '../datetime/date_time.dart';

// object from main.dart
final _myBox = Hive.box("Tracker_DB");

class TrackerDB {
  List taskList = [];

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
    // calculateHabitPercentages();
    // loadHeatMap();
  }

}