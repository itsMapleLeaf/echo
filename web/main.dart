import 'dart:html';

final CanvasElement canvas = querySelector('canvas');

num lerp(num a, num b, num delta) => a + (b - a) * delta.clamp(0, 1);

class Keyboard {
  static Map<int, bool> pressedKeys = {};

  static init() {
    window.onKeyDown.listen((event) => pressedKeys[event.keyCode] = true);
    window.onKeyUp.listen((event) => pressedKeys[event.keyCode] = false);
  }

  static bool isDown(int key) => pressedKeys[key] == true;
}

abstract class Prop {}

class Actor {
  Map<Type, Prop> props = {};

  Actor(List<Prop> proplist) {
    for (final prop in proplist) {
      add(prop);
    }
  }

  add(Prop prop) => props[prop.runtimeType] = prop;

  remove(Prop prop) => props.remove(prop.runtimeType);

  bool has(List<Type> propTypes) =>
    propTypes.every((type) => props.containsKey(type));

  Prop get(Type propType) => props[propType];
}

class Position implements Prop {
  num x, y;
  Position(this.x, this.y);
}

class Velocity implements Prop {
  num x = 0, y = 0;
}

class Size implements Prop {
  num width, height;
  Size(this.width, this.height);
}

class Color implements Prop {
  String color;
  Color(this.color);
}

class PlayerInput implements Prop {}

class Player extends Actor {
  Player() : super([
    new Position(100, 100),
    new Size(50, 50),
    new Color('#333'),
    new Velocity(),
    new PlayerInput(),
  ]);
}

class Game {
  List<Actor> actors = [];

  Game() {
    actors.add(new Player());
  }

  void update(num dt) {
    for (final actor in actors) {
      if (actor.has([Velocity, PlayerInput])) {
        var targetVel
          = Keyboard.isDown(KeyCode.LEFT) ? -400
          : Keyboard.isDown(KeyCode.RIGHT) ? 400
          : 0;

        Velocity vel = actor.get(Velocity);
        vel.x = lerp(vel.x, targetVel, dt * 12);
      }

      if (actor.has([Position, Velocity])) {
        Position pos = actor.get(Position);
        Velocity vel = actor.get(Velocity);

        pos.x += vel.x * dt;
        pos.y += vel.y * dt;
      }
    }
  }

  void draw() {
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

main() async {
  Keyboard.init();

  final game = new Game();

  var time = await window.animationFrame;
  while (true) {
    final now = await window.animationFrame;
    final elapsed = (now - time) / 1000;
    time = now;

    game.update(elapsed);

    clear();
    game.draw();
  }
}

clear() {
  canvas.context2D
    ..fillStyle = 'white'
    ..fillRect(0, 0, canvas.width, canvas.height);
}
