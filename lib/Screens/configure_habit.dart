import 'package:flutter/material.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:provider/provider.dart';

class ConfigureHabit extends StatefulWidget {
  const ConfigureHabit({super.key});

  @override
  State<ConfigureHabit> createState() => _ConfigureHabitState();
}

class _ConfigureHabitState extends State<ConfigureHabit> {
  final TextEditingController habitController = TextEditingController();

  @override
  void initState(){
    super.initState();
    Future.microtask((){
      context.read<HabitProvider>().fetchHabits();
    });

  }


  @override
  void dispose(){
    habitController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final habitprovider = context.watch<HabitProvider>();
    return Scaffold(
      backgroundColor:  const Color(0xfffff7ff),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff4D7DED),
        title: Text('Configure Habits'),

      ),
      body: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: habitController,
            decoration: InputDecoration(
              hintText: 'Habit Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
          ),
          const SizedBox(height: 20,),
           const Text(
              'Select Color:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                value: habitprovider.selectedColor,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items:habitprovider.colors.keys.map((colorName){
                  return DropdownMenuItem<String>(
                    value: colorName,
                    child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: habitprovider.colors[colorName],
                      borderRadius: BorderRadius.circular(6)
                    ),
                    alignment: Alignment.center,
                    child: Text(colorName, style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  );
                },).toList(),
                 onChanged: (value){
                  if(value != null){
                    habitprovider.changeColor(value);
                  }
                 })
              ),
            ),
            const SizedBox(height: 18),

               ElevatedButton(
              onPressed: habitprovider.isLoading
                  ? null
                  : () async {
                      await habitprovider.addHabit(
                        habitController.text,
                      );

                      habitController.clear();
                    },

              child: habitprovider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,

                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Add Habit'),
            ),

            const SizedBox(height: 10),
             Expanded(
              child: ListView.builder(
                itemCount: habitprovider.habits.length,
                itemBuilder: (context, index) {
                  final habit =
                      habitprovider.habits[index];
                  final colorName =
                      habit['color'];

                  return ListTile(

                    leading: Container(
                      width: 40,
                      height: 40,

                      decoration: BoxDecoration(
                        color: habitprovider
                            .colors[colorName],

                        shape: BoxShape.circle,
                      ),
                    ),

                    title: Text(
                      habit['name'],
                    ),

                    trailing: IconButton(
                      onPressed: () {
                        habitprovider.deleteHabit(
                          habit['id'],
                        );
                      },

                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
              )
             )

        ],
      ),
      )
    );
  }
}