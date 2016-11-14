import 'dart:async';
import 'dart:math';

import 'component.dart';
import 'component_graphics.dart';
import 'component_physics.dart';
import 'game_world.dart';
import 'util.dart';

class EchoSource extends Component {
  void update(self, dt, GameWorld world) {
    final box = self[BoundingBox] as BoundingBox;
    final physics = self[Physics] as Physics;
    if (physics.hitGround) {
      trigger(box.center, world);
    }
  }

  void trigger(Point center, GameWorld world) {
    for (final other in world.objects) {
      if (other.has(BoundingBox) && other.has(EchoRespondent)) {
        final otherCenter = (other[BoundingBox] as BoundingBox).center;
        final delay = center.distanceTo(otherCenter);
        final respondent = other[EchoRespondent] as EchoRespondent;

        new Future.delayed(new Duration(milliseconds: delay.round()), () {
          respondent.show();
        });
      }
    }
  }
}

class EchoRespondent extends Component {
  num visibility = 0;

  void update(self, dt, world) {
    visibility = lerp(visibility, 0, 7 * dt);
    final rect = self[DrawableRect] as DrawableRect;
    rect.opacity = visibility;
  }

  void show() {
    visibility = 1;
  }
}