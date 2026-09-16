import 'package:flutter/material.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/utils/date_utils.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  

  String _weeklyDateLable(DateTime date){
    const lables = ['MON' , 'TUE' , 'WED' , 'THU' , 'FRI' , 'SAT' , 'SUN'];
    return lables[date.weekday  - 1];
  }

  @override
  Widget build(BuildContext context) {
    final habitprovider = context.watch<HabitProvider>();
    final today = DateTime.now();
    final last7days = List.generate(7 , (i) => today.subtract(Duration(days: 6 - i)));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Weekly Report', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff4D7DED),

      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(columns: [
          const DataColumn(label: Text('Habit')),
          ...last7days.map((d) => DataColumn(label: Text(_weeklyDateLable(d)))),
        ], rows: habitprovider.habits.map((habit){
          final completions = habit['completions'] as Map<String , dynamic>? ?? {};
          return DataRow(cells: [
            DataCell(Text(habit['name'] ?? '')),
            ...last7days.map((d) {
              final done = completions[dateKey(d)] == true;
              return DataCell(Icon(done ? Icons.check_circle : Icons.cancel, color: done ? Colors.green : Colors.red,));
            }),
          ]);
        }).toList()
        ),
      ),
    );
  }
}