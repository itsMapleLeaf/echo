import 'color.dart';
import 'game_object.dart';

class Player extends GameObject {
  Player() {
    add(new BoundingBox(200, 200, 50, 50));
    add(new Velocity());
    add(new PlayerInput());
    add(new CollisionResolution());
    add(new DrawableRect(Color.gray));
  }
}