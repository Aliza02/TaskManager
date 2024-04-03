abstract class UserStates {}

class InitialState extends UserStates {}

class EnableGoogleSignin extends UserStates {}

class Userloading extends UserStates {
  bool loading;
  Userloading(this.loading);
}
// class UserLoaded extends UserStates{}
