import 'game_object.dart';

class GameWorld {
  List<GameObject> objects = [];

  void add(GameObject obj) {
    objects.add(obj);
  }

  void remove(GameObject obj) {
    objects.remove(obj);
  }

  void update(num dt) {
    for (final obj in objects) obj.update(dt, this);
  }

  void draw() {
    for (final obj in objects) obj.draw();
  }
}
