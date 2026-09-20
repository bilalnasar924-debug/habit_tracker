import 'package:flutter/material.dart';
import 'package:habit_tracker/providers/auth_provider.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:habit_tracker/providers/quote_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
 void initState() {
  super.initState();
  Future.microtask(() {
    context.read<HabitProvider>().fetchHabits();
    context.read<QuoteProvider>().fetchQuote();
  });
}
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final habitProvider = Provider.of<HabitProvider>(context);

    final todoHabits = habitProvider.habits
        .where((habit) => habit['isCompleted'] == false)
        .toList();

    final completedHabits = habitProvider.habits
        .where((habit) => habit['isCompleted'] == true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff4D7DED),
        title: Text(
          '${authProvider.username}',
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // DRAWER
      // =========================

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Configure Habits'),
              onTap: () {
                Navigator.pushNamed(context, '/configurehabit');
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Personal Info'),
              onTap: () {
               Navigator.pushNamed(context, '/personal_info');
              },
            ),

            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Report'),
              onTap: () {
                Navigator.pushNamed(context, '/report_screen');
              },
            ),

            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
               Navigator.pushNamed(context, '/notification_screen');
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Provider.of<AuthProvider>(
                  context,
                  listen: false,
                ).logout();

                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                );
              },
            ),
          ],
        ),
      ),

      // =========================
      // BODY
      // =========================

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Consumer<QuoteProvider>(builder:(context , quoteProvider , _) {
            if(quoteProvider.isLoading){
              return const Padding(padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator(),),
              );
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xff4D7DED).withOpacity(0.1),
               borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('"${quoteProvider.quote}"',
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
                const SizedBox(height: 6),
                Text('- ${quoteProvider.author}',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            );
          } ),

          // =========================
          // TO-DO
          // =========================
          const SizedBox(height: 15,),

          const Text(
            'TO-DO',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (todoHabits.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No habits to do',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ...todoHabits.map(
              (habit) => _todoHabit(
                context,
                habit,
                habitProvider,
              ),
            ),

          const SizedBox(height: 30),

          // =========================
          // COMPLETED
          // =========================

          const Text(
            'COMPLETED',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (completedHabits.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No completed habits',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ...completedHabits.map(
              (habit) => _completedHabit(
                context,
                habit,
                habitProvider,
              ),
            ),
        ],
      ),
    );
  }

  // =========================================================
  Widget _todoHabit(
    BuildContext context,
    Map<String, dynamic> habit,
    HabitProvider habitProvider,
  ) {
    return Dismissible(
      key: ValueKey(habit['id']),

      // Swipe RIGHT → LEFT
      direction: DismissDirection.endToStart,

      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 30,
        ),
      ),

      confirmDismiss: (direction) async {
             await habitProvider.toggleHabit(
             habit['id'],
              true,
            ); 

          return false;
        },

      child: _habitCard(context,habit),
    );
  }

  // =========================================================
  Widget _completedHabit(
    BuildContext context,
    Map<String, dynamic> habit,
    HabitProvider habitProvider,
  ) {
    return Dismissible(
      key: ValueKey(habit['id']),

      // Swipe LEFT → RIGHT
      direction: DismissDirection.startToEnd,

      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.undo,
          color: Colors.white,
          size: 30,
        ),
      ),

      confirmDismiss: (direction) async {
        await habitProvider.toggleHabit(
          habit['id'],
          false,
        );

        return false;
      },

      child: _habitCard(context,habit),
    );
  }

  // =========================================================
  Widget _habitCard(BuildContext context, Map<String, dynamic> habit) {
    final String name = habit['name'] ?? 'Unnamed Habit';
    final String colorName = habit['color'] ?? 'Amber';
    final bool isCompleted = habit['isCompleted'] ?? false;

    final Color habitColor =
        context.read<HabitProvider>().colors[colorName] ??
        Colors.amber;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: habitColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 8,
          height: 45,
          decoration: BoxDecoration(
            color: habitColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        title: Text(
          name,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            decoration:
                isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),

        trailing: Icon(
          isCompleted
              ? Icons.check_circle
              : Icons.circle_outlined,
          color: isCompleted
              ? Colors.green
              : habitColor,
        ),
      ),
    );
  }
}