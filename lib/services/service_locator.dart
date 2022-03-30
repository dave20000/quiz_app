import 'package:kiwi/kiwi.dart';
import 'package:quiz_app/ui/view_models/quiz.dart';

abstract class ServiceLocator {
  static KiwiContainer? container;

  static void setup() {
    container = KiwiContainer();
    container!.registerFactory((c) => QuizViewModel());
  }

  static final resolve = container!.resolve;
}
