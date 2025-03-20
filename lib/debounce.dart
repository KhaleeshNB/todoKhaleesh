import 'dart:async';

import 'package:flutter/widgets.dart';

class Debounce {
  final int milliSeconds;

  Debounce({this.milliSeconds = 500});

  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliSeconds), action);
  }
}
