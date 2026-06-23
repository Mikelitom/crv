class RequestThrottle {
  final Duration delay;
  DateTime _lastRequest = DateTime.fromMillisecondsSinceEpoch(0);

  RequestThrottle({this.delay = const Duration(milliseconds: 300)});

  Future<void> wait() async {
    final now = DateTime.now();
    final diff = now.difference(_lastRequest);

    if (diff < delay) {
      await Future.delayed(delay - diff);
    }

    _lastRequest = DateTime.now();
  }
}