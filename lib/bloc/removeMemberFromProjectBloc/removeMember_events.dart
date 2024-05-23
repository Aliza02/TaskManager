abstract class RemoveMemberFromProjectEvents {}

class RemoveMemberFromProject extends RemoveMemberFromProjectEvents {
  final String memberEmail;
  RemoveMemberFromProject({required this.memberEmail});
}
