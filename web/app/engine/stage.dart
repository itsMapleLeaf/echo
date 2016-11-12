import 'actor.dart';
import 'director.dart';

class Stage {
  final List<Actor> actors = [];
  final List<Director> directors;

  Stage(this.directors);

  void step() {
    for (final director in directors) {
      director.direct(actors.where(director.isValid));
    }
  }
}
