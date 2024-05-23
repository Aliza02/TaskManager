import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/bloc/addprojectBloc/project_events.dart';
import 'package:taskmanager/bloc/addprojectBloc/project_states.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/data/email/email_sending.dart';
import 'package:taskmanager/injection/database.dart';

class ProjectBloc extends Bloc<ProjectEvents, ProjectStates> {
  var addProject = locator<Database>;

  ProjectBloc() : super(InitialState()) {
    on<AddProject>((event, emit) async {
      if (event.projectName.isNotEmpty &&
          event.projectDescription.isNotEmpty &&
          event.memberEmail.isNotEmpty) {
        bool added = await addProject().addWorkspace(
            email: event.memberEmail,
            projectDescription: event.projectDescription,
            projectName: event.projectName,
            creationDate: event.creationDate);

        if (added) {
          print(event.memberEmail.length);

          emit(ProjectAdded("Project has been created Successfully"));
        } else {
          emit(ErrorState("Project is not created: Try Again"));
        }
      } else {
        emit(ErrorState("Fill all the fields carefully"));
      }
    });
  }
}
