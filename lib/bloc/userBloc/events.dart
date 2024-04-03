abstract class UserEvents {}

class LoginSignupEvent extends UserEvents {}

class GoogleSigning extends UserEvents {
  bool loading;
  GoogleSigning(this.loading);
}

class Logout extends UserEvents{
  bool isLogout;
  Logout(this.isLogout);
}
