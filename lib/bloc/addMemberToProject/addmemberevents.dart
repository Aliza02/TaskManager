abstract class AddMemberToProjectEvents {}

class AddMemberToProject extends AddMemberToProjectEvents {
  final String memberEmail;
  AddMemberToProject({required this.memberEmail});
}
