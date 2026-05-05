import 'dart:async';

class LoadingBus {
  LoadingBus._();

  static int _count = 0;
  static final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  static bool get isLoading => _count > 0;

  static Stream<bool> get stream => _controller.stream;

  static void start() {
    _count += 1;
    _emit();
  }

  static void stop() {
    _count = _count > 0 ? _count - 1 : 0;
    _emit();
  }

  static void _emit() {
    if (!_controller.isClosed) {
      _controller.add(isLoading);
    }
  }
}
