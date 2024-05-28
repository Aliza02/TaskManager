import 'package:get_it/get_it.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/notification/notification_services.dart';

GetIt locator = GetIt.instance;
void setup() {
  locator.registerSingleton(Database());
  locator.registerSingleton(NotificationServices());
  // locator.registerFactory<Database>(() => Database());
}
