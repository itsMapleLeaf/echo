class Clock {
  num time = new DateTime.now().millisecondsSinceEpoch;

  num step() {
    num now = new DateTime.now().millisecondsSinceEpoch;
    num elapsed = (now - time) / 1000;
    time = now;
    return elapsed;
  }
}