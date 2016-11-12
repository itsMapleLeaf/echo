import 'dart:html';

import 'actor.dart';
import 'graphics.dart';
import 'keyboard.dart';
import 'player.dart';
import 'props.dart';
import 'util.dart';
import 'clock.dart';

class InputDirector {
  final clock = new Clock();

  bool isValid(Actor actor) => actor.has([Velocity, PlayerInput]);

  void direct(List<Actor> actors) {
    num dt = clock.step();

    for (final actor in actors) {
      var targetVel
        = Keyboard.isDown(KeyCode.LEFT) ? -400
        : Keyboard.isDown(KeyCode.RIGHT) ? 400
        : 0;

      Velocity vel = actor.get(Velocity);
      vel.x = lerp(vel.x, targetVel, dt * 12);
    }
  }
}

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

class DrawingDirector {
  bool isValid(Actor actor) => actor.has([Position, Size, Color]);

  void direct(List<Actor> actors) {
    for (final actor in actors) {
      if (actor.has([Position, Size, Color])) {
        Position pos = actor.get(Position);
        Size size = actor.get(Size);
        Color color = actor.get(Color);

        canvas.context2D
          ..fillStyle = color.color
          ..fillRect(pos.x, pos.y, size.width, size.height);
      }
    }
  }
}

class Game {
  List<Actor> actors = [];

  final input = new InputDirector();
  final physics = new PhysicsDirector();
  final drawing = new DrawingDirector();

  Game() {
    actors.add(new Player());
  }

  void update(num dt) {
    input.direct(actors.where(input.isValid));
    physics.direct(actors.where(physics.isValid));
  }

  void draw() {
    drawing.direct(actors.where(drawing.isValid));
  }
}
