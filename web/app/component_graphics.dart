import 'component.dart';
import 'component_physics.dart';
import 'color.dart';
import 'graphics.dart';

class DrawableRect extends Component {
  Color color;
  num opacity = 1;

  DrawableRect(this.color);

  void draw(self) {
    final box = self[BoundingBox];
    drawRectangle(box.x, box.y, box.width, box.height, color.withOpacity(opacity));
  }
}