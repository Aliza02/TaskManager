import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/bloc/memberBloc/member_events.dart';
import 'package:taskmanager/bloc/memberBloc/member_states.dart';


class MemberBloc extends Bloc<MemberEvent, MembersStates> {
  List<String> temp = [];
  MemberBloc() : super(InitialState()) {
    on<AddMember>((event, emit) {
      temp.add(event.member);
      print(temp.length);
      emit(MemberAdded(temp));
    });

    on<RemoveMember>((event, emit) {
      temp.removeAt(event.index);
      emit(MemberRemoved(temp));
    });
    on<ErrorEvent>((event, emit) {
      emit(MemberErrorState(event.message));
    });

    on<AddAllMember>((event, emit) {
      temp.clear();
      emit(AllMembersAdded(temp));
    });
  }
}
