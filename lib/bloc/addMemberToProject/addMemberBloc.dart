import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:taskmanager/bloc/addMemberToProject/addMemberstates.dart';
import 'package:taskmanager/bloc/addMemberToProject/addmemberevents.dart';
import 'package:taskmanager/controllers/project_controller.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/data/email/email_sending.dart';
import 'package:taskmanager/injection/database.dart';

class AddMemberToProjectBloc
    extends Bloc<AddMemberToProjectEvents, AddMemberToProjectStates> {
  var project = locator<Database>;
  final projetController = Get.put(ProjectController());
  AddMemberToProjectBloc() : super(InitialState()) {
    on<AddMemberToProject>((event, emit) async {
      try {
        if (event.memberEmail.isNotEmpty) {
          SendEmail.sendEmail(
            email: [event.memberEmail],
            projectName: projetController.projectName.value,
            subject: projetController.projectName.value,
          );
          await project().addMemberToProject(email: event.memberEmail);

          emit(MemberAddedToProjectState(message: 'Member Added Successfully'));
        } else {
          emit(AddErrorState(message: 'Failed to add member'));
        }
      } catch (e) {
        emit(AddErrorState(message: e.toString()));
      }
    });
  }
}
