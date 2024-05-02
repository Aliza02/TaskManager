abstract class TaskEvents {}

class AddTasks extends TaskEvents {
  String taskName;
  String taskDescription;
  String deadlineDate;
  String deadlineTime;
  List<String> member;
  AddTasks(
      {required this.taskName,
      required this.taskDescription,
      required this.deadlineDate,
      required this.deadlineTime,
      required this.member});
}
