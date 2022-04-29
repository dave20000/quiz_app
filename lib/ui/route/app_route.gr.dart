// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:quiz_app/models/result.dart' as _i6;
import 'package:quiz_app/ui/screens/home/home_screen.dart' as _i1;
import 'package:quiz_app/ui/screens/quiz/quiz_screen.dart' as _i2;
import 'package:quiz_app/ui/screens/quiz_result/quiz_result_screen.dart' as _i3;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return _i4.AdaptivePage<dynamic>(
          routeData: routeData, child: _i1.HomeScreen(key: args.key));
    },
    QuizRoute.name: (routeData) {
      final args = routeData.argsAs<QuizRouteArgs>();
      return _i4.CustomPage<dynamic>(
          routeData: routeData,
          child: _i2.QuizScreen(key: args.key, quizUrl: args.quizUrl),
          transitionsBuilder: _i4.TransitionsBuilders.slideLeft,
          opaque: true,
          barrierDismissible: false);
    },
    QuizResultRoute.name: (routeData) {
      final args = routeData.argsAs<QuizResultRouteArgs>();
      return _i4.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.QuizResultScreen(key: args.key, result: args.result),
          transitionsBuilder: _i4.TransitionsBuilders.zoomIn,
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(HomeRoute.name, path: '/'),
        _i4.RouteConfig(QuizRoute.name, path: '/quiz-screen'),
        _i4.RouteConfig(QuizResultRoute.name, path: '/quiz-result-screen')
      ];
}

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i4.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({_i5.Key? key})
      : super(HomeRoute.name, path: '/', args: HomeRouteArgs(key: key));

  static const String name = 'HomeRoute';
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.QuizScreen]
class QuizRoute extends _i4.PageRouteInfo<QuizRouteArgs> {
  QuizRoute({_i5.Key? key, required String quizUrl})
      : super(QuizRoute.name,
            path: '/quiz-screen',
            args: QuizRouteArgs(key: key, quizUrl: quizUrl));

  static const String name = 'QuizRoute';
}

class QuizRouteArgs {
  const QuizRouteArgs({this.key, required this.quizUrl});

  final _i5.Key? key;

  final String quizUrl;

  @override
  String toString() {
    return 'QuizRouteArgs{key: $key, quizUrl: $quizUrl}';
  }
}

/// generated route for
/// [_i3.QuizResultScreen]
class QuizResultRoute extends _i4.PageRouteInfo<QuizResultRouteArgs> {
  QuizResultRoute({_i5.Key? key, required _i6.Result result})
      : super(QuizResultRoute.name,
            path: '/quiz-result-screen',
            args: QuizResultRouteArgs(key: key, result: result));

  static const String name = 'QuizResultRoute';
}

class QuizResultRouteArgs {
  const QuizResultRouteArgs({this.key, required this.result});

  final _i5.Key? key;

  final _i6.Result result;

  @override
  String toString() {
    return 'QuizResultRouteArgs{key: $key, result: $result}';
  }
}
