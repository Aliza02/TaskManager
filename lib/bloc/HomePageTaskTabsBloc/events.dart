abstract class tabBarEvents {}

class activeTab extends tabBarEvents {
  final int index;
  activeTab({required this.index});
}
