abstract class BottomNavBarState {}

class NavigationChanged extends BottomNavBarState {
  final int index;
  NavigationChanged({required this.index});
}