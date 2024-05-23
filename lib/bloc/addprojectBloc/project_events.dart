abstract class ProjectEvents {}

class AddProject extends ProjectEvents {
  String projectName;
  String projectDescription;
  List<String> memberEmail;
  String creationDate;
  AddProject(this.projectName, this.projectDescription, this.memberEmail,
      this.creationDate);
}
