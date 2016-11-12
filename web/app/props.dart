import 'engine/prop.dart';

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