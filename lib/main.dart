import 'package:flutter/material.dart';
import 'package:habittute/database/habit_database.dart';
import 'package:habittute/pages/home_page.dart';
import 'package:habittute/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize database
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLanchDate();

  runApp(
    MultiProvider(
      providers: [
        // habit provider
        ChangeNotifierProvider(create: (context) => HabitDatabase()),

        // theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: const HomePage(),
        theme: Provider.of<ThemeProvider>(context).theme
        //theme: lightMode,
        );
  }
}
