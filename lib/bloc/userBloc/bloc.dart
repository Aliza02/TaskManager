import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/data/Authentications/google_signin.dart';
import 'package:taskmanager/bloc/userBloc/events.dart';
import 'package:taskmanager/bloc/userBloc/states.dart';

class LoginSignUpBloc extends Bloc<UserEvents, UserStates> {
  LoginSignUpBloc() : super(InitialState()) {
    on<LoginSignupEvent>((event, emit) {
      emit(EnableGoogleSignin());
    });

    on<GoogleSigning>((event, emit) async {
      if (event.loading == true) {
        UserCredential? user = await Auth.googleSignin();
        event.loading = false;
        emit(Userloading(event.loading));
      } else {
        emit(Userloading(event.loading));
      }
    });

    on<Logout>((event, emit) {
      if (event.isLogout == false) {
        Auth.GoogleLogout();
        event.isLogout = true;
        emit(Userloading(event.isLogout));
      } else {
        emit(Userloading(event.isLogout));
      }
    });
  }
}
