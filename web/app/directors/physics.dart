import '../actor.dart';
import '../clock.dart';
import '../props.dart';

class PhysicsDirector {
  final clock = new Clock();

  bool isValid(Actor actor) => actor.has([Position, Velocity]);

  void direct(List<Actor> actors) {
    num dt = clock.step();

    for (final actor in actors) {
      Position pos = actor.get(Position);
      Velocity vel = actor.get(Velocity);

      pos.x += vel.x * dt;
      pos.y += vel.y * dt;
    }
  }
}