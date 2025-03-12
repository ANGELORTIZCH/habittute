import 'package:flutter/material.dart';
import 'package:habittute/models/app_settings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*

S E T  U  P

  */

  // I N I T I A L I Z E - D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // Save first date of app startup (for heat map)
  Future<void> saveFirstLanchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }
  // Get first date of app startup (for heat map)
Future<DateTime?> getFirstLanchDate() async {
   final settings = await isar.appSettings.where().findFirst();
   return settings?.firstLaunchDate;
  /*

C R U D X O P E R A T I O N S 

  */

  // List of habits

  // C R E A T E - add a new habit

  // R E A D - read saved habits from db

  // U P D A T E - check habit on and off

  // U P D A T E - edit habit name

  // D E L E T E - delete habit
}
