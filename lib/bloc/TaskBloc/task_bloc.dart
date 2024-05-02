import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/bloc/TaskBloc/task_events.dart';
import 'package:taskmanager/bloc/TaskBloc/task_states.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';

class TaskBloc extends Bloc<TaskEvents, TaskStates> {
  var project = locator<Database>;
  TaskBloc() : super(InitialState()) {
    on<AddTasks>((event, emit) async {
      if (event.taskName.isNotEmpty &&
          event.taskDescription.isNotEmpty &&
          event.deadlineDate.isNotEmpty &&
          event.deadlineTime.isNotEmpty) {
        print(event.member);
        bool added = await project().addTaskToProject(
            task: event.taskName,
            description: event.taskDescription,
            date: event.deadlineDate,
            time: event.deadlineTime,
            members: event.member);

        if (added) {
          emit(TaskAdded(message: 'Your task has been adde to Project'));
        } else {
          emit(ErrorState('Task has not been added to project: Try Again'));
        }
      } else {
        emit(ErrorState(
            'Some error occur due to which project is not added: Try Again'));
      }
    });
  }
}
