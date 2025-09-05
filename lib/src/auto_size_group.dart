part of '../flutter_auto_size_text.dart';

/// Controller to synchronize the fontSize of multiple AutoSizeTexts.
class AutoSizeGroup {
  final _listeners = <_AutoSizeBuilderState, double>{};
  var _widgetsNotified = false;

  void _register(_AutoSizeBuilderState text) {
    _listeners[text] = double.infinity;
  }

  double get _effectiveMaxPossibleFontSize {
    final minMaxPossibleFontSize = _listeners.values.fold<double>(
        double.infinity,
        (previousValue, element) =>
            element < previousValue ? element : previousValue);
    return minMaxPossibleFontSize;
  }

  void _updateFontSize(_AutoSizeBuilderState text, double maxPossibleFontSize) {
    final oldEffectiveMaxPossibleFontSize = _effectiveMaxPossibleFontSize;
    _listeners[text] = maxPossibleFontSize;
    final newEffectiveMaxPossibleFontSize = _effectiveMaxPossibleFontSize;

    if (oldEffectiveMaxPossibleFontSize != newEffectiveMaxPossibleFontSize) {
      _widgetsNotified = false;
      scheduleMicrotask(_notifyListeners);
    }
  }

  void _notifyListeners() {
    if (_widgetsNotified) {
      return;
    } else {
      _widgetsNotified = true;
    }

    for (final textState in _listeners.keys) {
      if (textState.mounted) {
        textState._notifySync();
      }
    }
  }

  void _remove(_AutoSizeBuilderState text) {
    _updateFontSize(text, double.infinity);
    _listeners.remove(text);
  }
}
