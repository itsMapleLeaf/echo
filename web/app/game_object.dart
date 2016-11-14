import 'dart:math';

import 'color.dart';
import 'game_world.dart';
import 'graphics.dart';
import 'keyboard.dart';
import 'util.dart';

abstract class GameObject {
  final components = <Type, Component>{};

  void add(Component c) {
    components[c.runtimeType] = c;
  }

  bool has(Type ctype) => components.containsKey(ctype);

  void update(num dt, GameWorld world) {
    for (final c in components.values) c.update(this, dt, world);
  }

  void draw() {
    for (final c in components.values) c.draw(this);
  }

  dynamic operator [](Type ctype) => components[ctype];
}

abstract class Component {
  void update(GameObject self, num dt, GameWorld world) {}
  void draw(GameObject self) {}
}

class BoundingBox extends Component {
  num x, y, width, height;

  BoundingBox(this.x, this.y, this.width, this.height);

  Rectangle get rect => new Rectangle(x, y, width, height);

  void setPosition(num _x, num _y) {
    x = _x;
    y = _y;
  }

  void setSize(num _width, num _height) {
    width = _width;
    height = _height;
  }

  void setCenterPosition(num cx, num cy) {
    x = cx - width / 2;
    y = cy - height / 2;
  }
}

class Velocity extends Component {
  num vx = 0;
  num vy = 0;
  num gravity = 2500;

  void update(self, dt, world) {
    final box = self[BoundingBox];
    vy += gravity * dt;
    box.x += vx * dt;
    box.y += vy * dt;
  }
}

class PlayerInput extends Component {
  static const jumpSpeed = 800;

  final kb = new Keyboard();

  num walking = 0;
  num walkSpeed = 500;

  void update(self, dt, world) {
    final vel = self[Velocity];

    num target = 0;
    if (kb.isDown(KeyCode.LEFT)) target -= 1;
    if (kb.isDown(KeyCode.RIGHT)) target += 1;
    walking = target;

    if (kb.wasPressed(KeyCode.UP)) {
      vel.vy = -jumpSpeed;
    }

    vel.vx = lerp(vel.vx, walking * walkSpeed, dt * 16);
  }
}

class CollisionResolution extends Component {
  static Point getCenter(Rectangle rect) {
    return (rect.topLeft + rect.bottomRight) * 0.5;
  }

  static List<Rectangle> sortByDistance(List<Rectangle> rects, Point point) {
    return new List<Rectangle>.from(rects)
      ..sort((a, b) {
        final dist1 = point.distanceTo(getCenter(a));
        final dist2 = point.distanceTo(getCenter(b));
        return dist1.compareTo(dist2);
      });
  }

  static Rectangle move(Rectangle rect, num dx, num dy) {
    final left = rect.left + dx;
    final top = rect.top + dy;
    return new Rectangle(left, top, rect.width, rect.height);
  }

  static Point getDisplacement(Rectangle self, List<Rectangle> others) {
    num dx = 0, dy = 0;

    for (final other in others) {
      final selfCenter = getCenter(self);
      final sect = other.intersection(self);
      if (sect != null) {
        if (sect.width < sect.height && sect.width != 0) {
          if (selfCenter.x < getCenter(other).x) {
            dx -= sect.width;
          } else {
            dx += sect.width;
          }
        }
        if (sect.height < sect.width && sect.height != 0) {
          if (selfCenter.y < getCenter(other).y) {
            dy -= sect.height;
          } else {
            dy += sect.height;
          }
        }
      }
      self = move(self, dx, dy);
    }

    return new Point(dx, dy);
  }

  void update(self, dt, world) {
    final box = self[BoundingBox] as BoundingBox;
    final vel = self[Velocity];

    final worldRects = world.objects
      .where((obj) => obj != self && obj.has(BoundingBox))
      .map((obj) => (obj[BoundingBox] as BoundingBox).rect);

    final selfRect = new Rectangle(box.x, box.y, box.width, box.height);
    final selfCenter = getCenter(selfRect);

    final closestToFurthest = sortByDistance(worldRects, selfCenter);
    final disp = getDisplacement(selfRect, closestToFurthest);

    box.x += disp.x;
    box.y += disp.y;

    if (disp.x != 0 && vel.vx.sign != disp.x.sign) vel.vx = 0;
    if (disp.y != 0 && vel.vy.sign != disp.y.sign) vel.vy = 0;
  }
}

class DrawableRect extends Component {
  Color color;

  DrawableRect(this.color);

  void draw(self) {
    final box = self[BoundingBox];
    drawRectangle(box.x, box.y, box.width, box.height, color);
  }
}