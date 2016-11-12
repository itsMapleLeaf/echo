import 'engine/prop.dart';

class Position implements Prop {
  num x, y;
  Position(this.x, this.y);
}

class Velocity implements Prop {
  num x, y, gravity;
  Velocity([this.x = 0, this.y = 0], {this.gravity: 0});
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