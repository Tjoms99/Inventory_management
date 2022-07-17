import 'package:flutter/material.dart';

///Creates a transition when transfering between two pages using [PageRouteBuilder].
class PageRouter extends PageRouteBuilder {
  final Widget child;
  final AxisDirection? direction;

  PageRouter({required this.child, required this.direction})
      : super(
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  ///Builds the [SlideTransition].
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: getBeginOffset(),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  ///Returns the [Offset] from where the page should start the transition.
  ///
  ///Four transitions is used [AxisDirection.up], [AxisDirection.down], [AxisDirection.left], [AxisDirection.right].
  Offset getBeginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.left:
        return const Offset(1, 0);
      case AxisDirection.right:
        return const Offset(-1, 0);
      default:
        return const Offset(0, 0);
    }
  }
}
