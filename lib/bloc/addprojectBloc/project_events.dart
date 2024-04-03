abstract class ProjectEvents {}

class AddProject extends ProjectEvents {
  String projectName;
  String projectDescription;
  String memberEmail;
  AddProject(this.projectName, this.projectDescription, this.memberEmail);
}
