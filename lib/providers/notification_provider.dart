import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_tracker/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationProvider  extends ChangeNotifier{
  bool _enabled = false;
  List<String> _selectedHabits = [];
  List<TimeOfDay> _seletedTime = [];

  bool get enabled => _enabled;
  List<String> get selectedHabits => _selectedHabits;
  List<TimeOfDay> get selectedTime => _seletedTime;

  Future<void> loadPrefrence() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool('notif_enabled') ?? false;
    _selectedHabits = prefs.getStringList('notif_habit_ids') ?? [];
    final timeString = prefs.getStringList('notif_times') ?? [];
    _seletedTime = timeString.map((t){
      final parts = t.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();
    notifyListeners();
  }

  Future<void> savePrefrences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enabled', _enabled);
    await prefs.setStringList('notif_habit_ids', _selectedHabits);
    await prefs.setStringList('notif_times', _seletedTime.map((t) => '${t.hour}:${t.minute}').toList());
  }

  void toggleEnabled(bool value) {
    _enabled = value;
    notifyListeners();
  }

  void toggleHabit(String habitid) {
    if(_selectedHabits.contains(habitid)){
      _selectedHabits.remove(habitid);
    }else{
      _selectedHabits.add(habitid);
    }
    notifyListeners();
  }

  void addTime(TimeOfDay time){
    _seletedTime.add(time);
    notifyListeners();
  }
  void deleteTime(TimeOfDay time){
    _seletedTime.remove(time);
    notifyListeners();
  }
  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(
    tz.local, now.year, now.month, now.day, time.hour, time.minute,
  );
  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

  Future<void> scheduleNotification(List<Map<String,dynamic>> habits) async{
    await notificationsPlugin.cancelAll();
    debugPrint('enabled=$_enabled, selectedHabits=$_selectedHabits, selectedTimes=$_seletedTime');
    if(!_enabled) return;

    int notificationId = 0;
    for(final habitid in _selectedHabits){
      final habit = habits.firstWhere((h) => h['id'] == habitid, orElse: () => {});
      final habitName = habit['name'] ?? 'habit';
        debugPrint('Processing habit: $habitName (id=$habitid)');
      for(final time in _seletedTime){
        final scheduleDate = _nextInstanceOfTime(time);
        debugPrint('Scheduling "$habitName" for $scheduleDate (now=${tz.TZDateTime.now(tz.local)})');
        await notificationsPlugin.zonedSchedule(id: notificationId++ , title: 'Habit Reminder' ,body:  'Time for : $habitName' , scheduledDate: scheduleDate ,notificationDetails:  const NotificationDetails(
          android: AndroidNotificationDetails('habit_channel', 'Habit Reminders', importance: Importance.high),
        ),androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time
        );
         debugPrint('Scheduled successfully, id=${notificationId - 1}');
      }
    }
  }

}