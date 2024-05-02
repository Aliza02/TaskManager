abstract class MembersStates {}

class InitialState extends MembersStates {}

class MemberAdded extends MembersStates {
  List<String> members;
  MemberAdded(this.members);
}

class MemberRemoved extends MembersStates {
  List<String> members;
  MemberRemoved(this.members);
}

class AllMembersAdded extends MembersStates {
  List<String> emptyListOfMembers;
  AllMembersAdded(this.emptyListOfMembers);
}

class MemberErrorState extends MembersStates {
  String message;
  MemberErrorState(this.message);
}
