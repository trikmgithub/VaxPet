abstract class BottomNavBarEvent {}

class NavigateTo extends BottomNavBarEvent {
  final int index;
  NavigateTo({required this.index});
}
