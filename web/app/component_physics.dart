import 'dart:math';

import 'component.dart';
import 'game_world.dart';

class BoundingBox extends Component {
  num x, y, width, height;

  BoundingBox(this.x, this.y, this.width, this.height);

  Rectangle get rect => new Rectangle(x, y, width, height);

  Point get center => new Point(x + width / 2, y + height / 2);

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

class Physics extends Component {
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

  bool onGround = false;
  bool hitGround = false;

  void update(self, dt, GameWorld world) {
    final box = self[BoundingBox] as BoundingBox;
    final vel = self[Velocity];

    final worldRects = world.objects
      .where((obj) => obj != self && obj.has(BoundingBox))
      .map((obj) => (obj[BoundingBox] as BoundingBox).rect);

    final selfRect = box.rect;
    final selfCenter = box.center;

    final closestToFurthest = sortByDistance(worldRects, selfCenter);
    final disp = getDisplacement(selfRect, closestToFurthest);

    box.x += disp.x;
    box.y += disp.y;

    if (disp.x != 0 && vel.vx.sign != disp.x.sign) vel.vx = 0;
    if (disp.y != 0 && vel.vy.sign != disp.y.sign) vel.vy = 0;

    final _onGround = disp.y < 0;
    hitGround = _onGround && !onGround;
    onGround = _onGround;
  }
}