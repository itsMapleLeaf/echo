import 'dart:math';

import 'color.dart';
import 'graphics.dart';
import 'keyboard.dart';
import 'util.dart';

class Player {
  final kb = new Keyboard();

  num x = 200;
  num y = 200;
  num vx = 0;
  num vy = 0;
  num width = 50;
  num height = 50;
  num walkSpeed = 500;
  num gravity = 2500;
  num walking = 0;
  var color = new Color(0.3, 0.3, 0.3);

  void respondToInput() {
    num target = 0;
    if (kb.isDown(KeyCode.LEFT)) target -= 1;
    if (kb.isDown(KeyCode.RIGHT)) target += 1;
    walking = target;

    if (kb.wasPressed(KeyCode.UP)) {
      vy = -800;
    }
  }

  void updatePosition(num dt) {
    vx = lerp(vx, walking * walkSpeed, dt * 16);
    vy += gravity * dt;

    x += vx * dt;
    y += vy * dt;
  }

  Point getCenter(Rectangle rect) {
    return (rect.topLeft + rect.bottomRight) * 0.5;
  }

  void resolveCollisions(List<Rectangle> rects) {
    final selfRect = new Rectangle(x, y, width, height);
    final selfCenter = getCenter(selfRect);

    final closestToFurthest = new List<Rectangle>.from(rects)
      ..sort((a, b) {
        final dist1 = selfCenter.distanceTo(getCenter(a));
        final dist2 = selfCenter.distanceTo(getCenter(b));
        return dist1.compareTo(dist2);
      });

    for (final other in closestToFurthest) {
      final selfRect = new Rectangle(x, y, width, height);
      final selfCenter = getCenter(selfRect);
      final sect = other.intersection(selfRect);
      if (sect != null) {
        if (sect.width < sect.height && sect.width != 0) {
          if (selfCenter.x < getCenter(other).x) {
            x -= sect.width;
            if (vx > 0) vx = 0;
          } else {
            x += sect.width;
            if (vx < 0) vx = 0;
          }
        }
        if (sect.height < sect.width && sect.height != 0) {
          if (selfCenter.y < getCenter(other).y) {
            y -= sect.height;
            if (vy > 0) vy = 0;
          } else {
            y += sect.height;
            if (vy < 0) vy = 0;
          }
        }
      }
    }
  }

  void draw() {
    drawRectangle(x, y, width, height, color);
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
    '          ',
    '          ',
    '          ',
    '          ',
    '          ',
    '      1   ',
    '      1   ',
    '      1   ',
    '1111111111',
  ]);

  update(num dt) {
    player.respondToInput();
    player.updatePosition(dt);
    player.resolveCollisions(map.blocks);
  }

  draw() {
    clear(Color.white);
    player.draw();
    map.draw();
  }
}
