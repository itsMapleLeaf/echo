import 'game_world.dart';
import 'game_object.dart';

abstract class Component {
  void update(GameObject self, num dt, GameWorld world) {}
  void draw(GameObject self) {}
}