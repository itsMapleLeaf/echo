import 'color.dart';
import 'component_echo.dart';
import 'component_graphics.dart';
import 'component_physics.dart';
import 'component_input.dart';
import 'game_object.dart';

class Player extends GameObject {
  Player() {
    add(new BoundingBox(200, 200, 50, 50));
    add(new Velocity());
    add(new PlayerInput());
    add(new Physics());
    add(new EchoSource());
    add(new DrawableRect(Color.gray));
  }
}