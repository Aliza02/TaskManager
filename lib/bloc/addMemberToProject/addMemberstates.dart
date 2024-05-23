abstract class AddMemberToProjectStates {}

class InitialState extends AddMemberToProjectStates {}

class MemberAddedToProjectState extends AddMemberToProjectStates {
  final String message;
  MemberAddedToProjectState({required this.message});
}

class AddErrorState extends AddMemberToProjectStates {
  final String message;
  AddErrorState({required this.message});
}
