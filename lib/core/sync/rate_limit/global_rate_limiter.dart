class GlobalRateLimiter {
  final Duration minInterval;
  DateTime _last = DateTime.fromMillisecondsSinceEpoch(0);
  bool _locked = false;

  GlobalRateLimiter({this.minInterval = const Duration(milliseconds: 400)});

  Future<void> acquire() async {
    while (_locked) {
      await Future.delayed(const Duration(milliseconds: 10));
    }

    _locked = true;

    try {
      final now = DateTime.now();
      final diff = now.difference(_last);

      if (diff < minInterval) {
        await Future.delayed(minInterval - diff);
      }

      _last = DateTime.now();
    } finally {
      _locked = false;
    }
  }
}