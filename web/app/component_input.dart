import 'component.dart';
import 'component_physics.dart';
import 'keyboard.dart';
import 'util.dart';

class PlayerInput extends Component {
  static const jumpSpeed = 800;

  final kb = new Keyboard();

  num walking = 0;
  num walkSpeed = 500;
  int jumps = 0;

  void update(self, dt, world) {
    final vel = self[Velocity];
    final physics = self[Physics];

    num target = 0;
    if (kb.isDown(KeyCode.LEFT)) target -= 1;
    if (kb.isDown(KeyCode.RIGHT)) target += 1;
    walking = target;

    if (kb.wasPressed(KeyCode.UP) && jumps > 0) {
      vel.vy = -jumpSpeed;
      jumps--;
    }
    vel.vx = lerp(vel.vx, walking * walkSpeed, dt * 16);

    if (physics.hitGround) {
      jumps = 2;
    }
  }
}