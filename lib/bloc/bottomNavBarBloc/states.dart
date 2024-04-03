abstract class NavBarStates {}

class Initial extends NavBarStates {}

class pageNavigate extends NavBarStates {
  final int index;
  pageNavigate({required this.index});
}
