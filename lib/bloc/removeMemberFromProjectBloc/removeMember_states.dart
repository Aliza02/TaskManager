abstract class RemoveMemberFromProjectStates {}

class InitialState extends RemoveMemberFromProjectStates {}

class MemberRemovedFromProjectState extends RemoveMemberFromProjectStates {
  final String message;
  MemberRemovedFromProjectState({required this.message});
}

class ErrorState extends RemoveMemberFromProjectStates {
  final String message;
  ErrorState({required this.message});
}
