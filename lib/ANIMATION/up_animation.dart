// import 'package:flutter/material.dart';

// class Uptransition extends PageRouteBuilder {
//   final Widget page;
//   Uptransition(this.page)
//       : super(
//           pageBuilder: (context, animation, anotherAnimation) => page,
//           transitionDuration: const Duration(milliseconds: 700),
//           reverseTransitionDuration: const Duration(milliseconds: 400),
//           transitionsBuilder: (context, animation, anotherAnimation, child) {
//             animation = CurvedAnimation(
//               parent: animation,
//               curve: Curves.easeInOut,
//               reverseCurve: Curves.easeInOut,
//             );
//             return Align(
//               alignment: Alignment.bottomCenter,
//               child: SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(0, 1),
//                   end: Offset.zero,
//                 ).animate(animation),
//                 child: FadeTransition(
//                   opacity: animation,
//                   child: page,
//                 ),
//               ),
//             );
//           },
//         );
// }
import 'package:flutter/material.dart';

class Uptransition extends PageRouteBuilder {
  final Widget page;

  Uptransition(this.page)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 850),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
              reverseCurve: Curves.easeInOutCubic,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.25),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}
