abstract class TaskStates {}

class InitialState extends TaskStates {}

class TaskAdded extends TaskStates {
  String message;
  TaskAdded({required this.message});
}

class ErrorState extends TaskStates {
  String message;
  ErrorState(this.message);
}
