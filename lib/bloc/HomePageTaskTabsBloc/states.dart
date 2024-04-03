abstract class tabBarStates {}

class activeState extends tabBarStates {
  final int index;
  activeState({required this.index});
}
