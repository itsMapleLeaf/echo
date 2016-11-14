import 'game_world.dart';
import 'component.dart';

abstract class GameObject {
  final components = <Type, Component>{};

  void add(Component c) { components[c.runtimeType] = c; }
  bool has(Type ctype) => components.containsKey(ctype);
  dynamic fetch(Type ctype) => components[ctype];

  void update(num dt, GameWorld world) {
    for (final c in components.values) c.update(this, dt, world);
  }

  void draw() {
    for (final c in components.values) c.draw(this);
  }

  dynamic operator [](Type ctype) => fetch(ctype);
}
