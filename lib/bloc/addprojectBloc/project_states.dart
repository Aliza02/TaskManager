abstract class ProjectStates {}

class InitialState extends ProjectStates {}

class ProjectAdded extends ProjectStates {
  String message;
  ProjectAdded(this.message);
}

class ErrorState extends ProjectStates {
  String message;
  ErrorState(this.message);
}
