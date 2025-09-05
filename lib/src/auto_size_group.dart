part of '../flutter_auto_size_text.dart';

/// Controller to synchronize the fontSize of multiple AutoSizeTexts.
class AutoSizeGroup {
  final _listeners = <_AutoSizeBuilderState, BoxConstraints>{};
  var _widgetsNotified = false;

  void _register(_AutoSizeBuilderState text) {
    _listeners[text] = const BoxConstraints();
  }

  BoxConstraints get _effectiveConstraints {
    const constraints = BoxConstraints();
    double maxWidth = constraints.maxWidth;
    double maxHeight = constraints.maxHeight;
    final groupConstraints = _listeners.values.nonNulls.toList();

    for (final groupConstraint in groupConstraints) {
      if (groupConstraint.maxWidth < maxWidth) {
        maxWidth = groupConstraint.maxWidth;
      }
      if (groupConstraint.maxHeight < maxHeight) {
        maxHeight = groupConstraint.maxHeight;
      }
    }

    final effectiveConstraints = BoxConstraints(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );

    return effectiveConstraints;
  }

  void _updateConstraints(
      _AutoSizeBuilderState text, BoxConstraints constraints) {
    final oldEffectiveConstraints = _effectiveConstraints;
    _listeners[text] = constraints;
    final newEffectiveConstraints = _effectiveConstraints;

    if (oldEffectiveConstraints != newEffectiveConstraints) {
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
    _updateConstraints(text, const BoxConstraints());
    _listeners.remove(text);
  }
}
