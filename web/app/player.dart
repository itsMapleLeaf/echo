import 'game_object.dart';
import 'game_world.dart';
import 'graphics.dart';

class Player extends GameObject
with BoundingBox, PlayerInput, Collideable, Jumping, Velocity, DrawableRect {
  Player() {
    setSize(50, 50);
  }

  void respawn() {
    setCenterPosition(canvas.width / 2, canvas.height / 2);
  }

  void update(num dt, GameWorld world) {
    updateInput(dt);
    updateVelocity(dt);
    resolveCollisions(world);
  }

  void draw() {
    drawRect();
  }
}