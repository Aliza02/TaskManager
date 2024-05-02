abstract class MemberEvent {}

class AddMember extends MemberEvent {
  String member;
  AddMember(this.member);
}

class RemoveMember extends MemberEvent {
  int index;
  RemoveMember(this.index);
}

class AddAllMember extends MemberEvent {}

class ErrorEvent extends MemberEvent {
  String message;
  ErrorEvent(this.message);
}
