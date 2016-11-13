import 'prop.dart';

class Actor {
  Map<Type, Prop> props = {};

  Actor(List<Prop> proplist) {
    for (final prop in proplist) {
      add(prop);
    }
  }

  void add(Prop prop) {
    props[prop.runtimeType] = prop;
  }

  void remove(Prop prop) {
    props.remove(prop.runtimeType);
  }

  bool has(List<Type> propTypes) =>
    propTypes.every((type) => props.containsKey(type));

  operator [](Type propType) =>
    props[propType];
}