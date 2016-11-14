import 'dart:math';

import 'color.dart';
import 'graphics.dart';
import 'keyboard.dart';
import 'util.dart';

abstract class GameObject {}

abstract class BoundingBox {
  num x = 0, y = 0, width = 0, height = 0;

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

abstract class Velocity implements BoundingBox {
  num vx = 0;
  num vy = 0;
  num gravity = 2500;

  void updatePosition(num dt) {
    x += vx * dt;
    y += vy * dt;
  }
}

abstract class Jumping implements Velocity {
  static const jumpSpeed = 800;

  void jump() {
    vy = -jumpSpeed;
  }
}

abstract class PlayerInput implements Jumping {
  final kb = new Keyboard();

  num walking = 0;
  num walkSpeed = 500;

  void respondToInput() {
    num target = 0;
    if (kb.isDown(KeyCode.LEFT)) target -= 1;
    if (kb.isDown(KeyCode.RIGHT)) target += 1;
    walking = target;

    if (kb.wasPressed(KeyCode.UP)) {
      jump();
    }
  }

  void updateVelocity(num dt) {
    vx = lerp(vx, walking * walkSpeed, dt * 16);
    vy += gravity * dt;
  }
}

abstract class Collideable implements BoundingBox, Velocity {
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

  void resolveCollisions(List<Rectangle> rects) {
    final selfRect = new Rectangle(x, y, width, height);
    final selfCenter = getCenter(selfRect);

    final closestToFurthest = sortByDistance(rects, selfCenter);
    final disp = getDisplacement(selfRect, closestToFurthest);

    x += disp.x;
    y += disp.y;

    if (disp.x != 0 && vx.sign != disp.x.sign) vx = 0;
    if (disp.y != 0 && vy.sign != disp.y.sign) vy = 0;
  }
}

abstract class DrawableRect implements BoundingBox {
  Color color = new Color(0.3, 0.3, 0.3);

  void draw() {
    drawRectangle(x, y, width, height, color);
  }
}

class Player extends GameObject
with BoundingBox, PlayerInput, Collideable, Jumping, Velocity, DrawableRect {
  Player() {
    setSize(50, 50);
    setCenterPosition(canvas.width / 2, canvas.height / 2);
  }

  void update(num dt) {
    respondToInput();
    updateVelocity(dt);
    updatePosition(dt);
  }
}


class Map {
  static const blockSize = 80;

  List<Rectangle> blocks = [];

  Map(List<String> mapData) {
    for (int i = 0; i < mapData.length; i++) {
      final row = mapData[i];
      for (int j = 0; j < row.length; j++) {
        final char = row[j];
        if (char == '1') {
          final left = j * blockSize;
          final top = i * blockSize;
          blocks.add(new Rectangle(left, top, blockSize, blockSize));
        }
      }
    }
  }

  void draw() {
    for (final block in blocks) {
      drawRectangle(block.left, block.top, block.width, block.height, Color.asphalt);
    }
  }
}

class Game {
  final player = new Player();

  final map = new Map([
    '                ',
    '                ',
    '                ',
    '                ',
    '                ',
    '      1         ',
    '      1         ',
    '      1         ',
    '1111111111111111',
  ]);

  update(num dt) {
    player.update(dt);
    if (player is Collideable) {
      player.resolveCollisions(map.blocks);
    }
  }

  draw() {
    clear(Color.white);
    player.draw();
    map.draw();
  }
}
