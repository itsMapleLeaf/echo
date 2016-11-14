import 'color.dart';
import 'graphics.dart';
import 'game_world.dart';
import 'player.dart';
import 'level.dart';

class Game {
  final world = new GameWorld();
  final player = new Player();

  Game() {
    new Level(world, [
      '                ',
      '   1    11      ',
      '   1            ',
      '1111        11  ',
      '                ',
      '        11      ',
      '   1            ',
      '   1            ',
      '1111111111111111',
    ]);

    world.add(player);
    // player.respawn();
  }

  update(num dt) {
    world.update(dt);
  }

  draw() {
    clear(Color.white);
    world.draw();
  }
}
