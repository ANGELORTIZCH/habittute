import 'package:isar/isar.dart';
// run cmd to generate file: dart run build_runner build

part 'app_settings.g.dart';

@Collection() // Añade esta anotación
class AppSettings {
  Id id = Isar.autoIncrement; // Este campo debe ser final
  DateTime? firstLaunchDate;
}
