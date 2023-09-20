import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracker_app/components/habit_tile.dart';
import 'package:tracker_app/components/month_summary.dart';
import 'package:tracker_app/components/my_fab.dart';
import 'package:tracker_app/data/tracker_db.dart';
import 'package:tracker_app/components/my_alert_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TrackerDB db = TrackerDB();
  final _myBox = Hive.box("Tracker_DB");

  @override
  void initState() {
    // first time user -> sample task list
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }

    // existing user -> load current data
    else {
      db.loadData();
    }

    // update the database
    db.updateDatabase();

    super.initState();
  }

  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.taskList[index][1] = value;
    });
    db.updateDatabase();
  }

  // new habit added
  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    showDialog(context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Enter your habit...',
          onSave: saveNewHabit,
          onCancel: closeHabitDialog,
        );
      },
    );
  }

  void saveNewHabit() {
    setState(() {
      db.taskList.add([_newHabitNameController.text, false]);
    });

    closeHabitDialog();
    db.updateDatabase();
  }
  
  void closeHabitDialog() {
    _newHabitNameController.clear(); // clear text
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: db.taskList[index][0],
          onSave: () => saveExistingHabit(index),
          onCancel: closeHabitDialog,
        );
      },
    );
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.taskList[index][0] = _newHabitNameController.text;
    });

    closeHabitDialog();
    db.updateDatabase();
  }

  void deleteHabit(int index) {
    setState(() {
      db.taskList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(''),
      // ),
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: Column( // can also use ListView ?
        children: [
          MonthlySummary(datasets: db.heatMapDataSet,
          startDate: _myBox.get("START_DATE"),),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.taskList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitName: db.taskList[index][0],
                habitCompleted: db.taskList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
                settingsTapped: (context) => openHabitSettings(index),
                deleteTapped: (context) => deleteHabit(index),
              );
            },
          ),
        ],
      ),
    );
  }
}