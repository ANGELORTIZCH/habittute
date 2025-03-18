import 'package:flutter/material.dart';
import 'package:habittute/components/my_habit_tile.dart';
import 'package:habittute/components/my_heat_map.dart';
import 'package:provider/provider.dart';
import 'package:habittute/components/my_drawer.dart';
import 'package:habittute/database/habit_database.dart';

import '../models/habit.dart';
import '../util/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Declaración del text controller antes de `initState`
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Asegurar que el context esté disponible antes de llamar a Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitDatabase>(context, listen: false).readHabits();
    });
  }

  @override
  void dispose() {
    textController.dispose(); // Liberar memoria del controlador
    super.dispose();
  }

  // Crear un nuevo hábito
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Habit"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Create a new habit"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String newHabitName = textController.text.trim();
              if (newHabitName.isNotEmpty) {
                context.read<HabitDatabase>().addHabit(newHabitName);
                textController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () {
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Marcar hábito como completado o no
  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // Editar un hábito
  void editHabitBox(Habit habit) {
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          TextButton(
            onPressed: () {
              String newHabitName = textController.text.trim();
              if (newHabitName.isNotEmpty) {
                context
                    .read<HabitDatabase>()
                    .updateHabitName(habit.id, newHabitName);
                textController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () {
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Eliminar un hábito
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          TextButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: ListView(
        children: [
          // H E A T M A P
          _buildHeatMap(),
          // H E A T M A P  L I S T
          _buildHabitList(),
        ],
      ),
    );
  }

  // build heat map
  Widget _buildHeatMap() {
    // habit database
    final habitDatabase = context.watch<HabitDatabase>();

    // current habit
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return heat UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLanchDate(),
      builder: (context, snapshot) {
        // once the data is available -> build heat map
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        }

        // hundle case where no data is returned
        else {
          return Container();
        }
      },
    );
  }

  // Construir la lista de hábitos
  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];

        // Verificar si la función `isHabitCompletedToday` está disponible
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (_) => editHabitBox(habit),
          deleteHabit: (_) => deleteHabitBox(habit),
        );
      },
    );
  }
}
