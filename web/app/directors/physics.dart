import '../engine/actor.dart';
import '../engine/director.dart';

import '../clock.dart';
import '../props.dart';

class PhysicsDirector implements Director {
  final clock = new Clock();

  bool isValid(Actor actor) => actor.has([Position, Velocity]);

  void direct(List<Actor> actors) {
    num dt = clock.step();

    for (final actor in actors) {
      Position pos = actor.get(Position);
      Velocity vel = actor.get(Velocity);

      vel.y += vel.gravity * dt;

      pos.x += vel.x * dt;
      pos.y += vel.y * dt;
    }
  }
}