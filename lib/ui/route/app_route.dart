import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/ui/screens/home/home_screen.dart';
import 'package:quiz_app/ui/screens/quiz/quiz_screen.dart';
import 'package:quiz_app/ui/screens/quiz_result/quiz_result_screen.dart';

import 'app_route.gr.dart';

final appRouterProvider = Provider.autoDispose(
  (ref) => AppRouter(),
);

@AdaptiveAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomeScreen, initial: true),
    CustomRoute(
      page: QuizScreen,
      transitionsBuilder: TransitionsBuilders.slideLeft,
    ),
    CustomRoute(
      page: QuizResultScreen,
      transitionsBuilder: TransitionsBuilders.zoomIn,
    ),
  ],
)
class $AppRouter {}
