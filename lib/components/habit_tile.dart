import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Checkbox(
              value: false, 
              onChanged: ((value) {})
            ),
            Text('Habit Tile Test #1'),
          ],
        ),
      ),
    );
  }
}
