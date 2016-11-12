import '../actor.dart';

abstract class Director {
  bool isValid(Actor actor);
  void direct(List<Actor> actors);
}