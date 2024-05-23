import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taskmanager/bloc/removeMemberFromProjectBloc/removeMember_events.dart';
import 'package:taskmanager/bloc/removeMemberFromProjectBloc/removeMember_states.dart';
import 'package:taskmanager/data/databse/database_functions.dart';
import 'package:taskmanager/injection/database.dart';

class RemoveMemberFromProjectBloc
    extends Bloc<RemoveMemberFromProjectEvents, RemoveMemberFromProjectStates> {
  var project = locator<Database>;
  RemoveMemberFromProjectBloc() : super(InitialState()) {
    on<RemoveMemberFromProject>((event, emit) async {
      try {
        if (event.memberEmail.isNotEmpty) {
          await project().removeMemberToProject(email: event.memberEmail);
          emit(MemberRemovedFromProjectState(
              message: 'Member Removed Successfully'));
        } else {
          emit(ErrorState(message: 'Failed to Remove member'));
        }
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });
  }
}
