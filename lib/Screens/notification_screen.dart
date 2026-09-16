import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<HabitProvider>().fetchHabits();
      await context.read<NotificationProvider>().loadPrefrence();
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();
    final notifProvider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff4D7DED),
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== ENABLE TOGGLE =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Enable Notifications',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                Switch(
                  value: notifProvider.enabled,
                  onChanged: (value) {
                    notifProvider.toggleEnabled(value);
                  },
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),

            // ===== HABIT SELECTION =====
            const Text('Select Habits for Notification',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: habitProvider.habits.map((habit) {
                final isSelected = notifProvider.selectedHabits.contains(habit['id']);
                return ChoiceChip(
                  label: Text(habit['name'] ?? ''),
                  selected: isSelected,
                  onSelected: (_) {
                    notifProvider.toggleHabit(habit['id']);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 25),

            // ===== TIME SELECTION =====
            const Text('Select Times for Notification',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ...notifProvider.selectedTime.map((time) {
                  return Chip(label: Text(time.format(context)),
                  onDeleted: (){
                    notifProvider.deleteTime(time);
                  },
                  );
                }),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Add Time'),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      notifProvider.addTime(picked);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ===== SAVE BUTTON =====
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(220, 45),
                  backgroundColor: const Color(0xff4D7DED),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await notifProvider.savePrefrences();
                  await notifProvider.scheduleNotification(habitProvider.habits);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications saved')),
                  );
                },
                child: const Text('Save Notifications'),
              ),
            ),
          
          
          ],
        ),
      ),
    );
  }
}