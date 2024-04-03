import 'package:get_it/get_it.dart';
import 'package:taskmanager/data/databse/database_functions.dart';

GetIt locator = GetIt.instance;
void setup() {
  locator.registerFactory<Database>(() => Database());
}
