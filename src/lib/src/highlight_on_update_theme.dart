import 'package:flutter/material.dart';
import 'package:highlight_on_update/highlight_on_update.dart';

import 'constants.dart';

/// Default theme of the [HighlightOnUpdateText] widget.
class HighlightOnUpdateTheme extends InheritedWidget {
  const HighlightOnUpdateTheme({
    super.key,
    required super.child,
    this.from = kDefaultFromColor,
    this.to = kDefaultToColor,
    this.inDuration = kDefaultInDuration,
    this.waitDuration = kDefaultWaitDuration,
    this.outDuration = kDefaultOutDuration,
    this.inCurve = kDefaultInCurve,
    this.outCurve = kDefaultOutCurve,
    this.borderRadius = kDefaultBorderRadius,
    this.updateAfterHighlighting,
  });

  /// Start color of the animation.
  ///
  /// Pay attention: if this won't be transparent, the text won't be visible.
  final Color? from;

  /// End color of the animation.
  ///
  /// Pay attention: if this won't be transparent, the text won't be visible.
  final Color? to;

  /// Duration of the highlighting fade in animation.
  final Duration? inDuration;

  /// For how long the text will be highlighted.
  final Duration? waitDuration;

  /// Duration of the highlighting fade out animation.
  final Duration? outDuration;

  /// Curve of the highlighting fade out animation.
  final Curve? inCurve;

  /// Curve of the highlighting fade in animation.
  final Curve? outCurve;

  /// Border radius of the highlighting.
  final BorderRadius? borderRadius;

  /// Whether to change the text immediately after it has been updated
  /// or to wait for the in animation to be completed.
  final bool? updateAfterHighlighting;

  @override
  bool updateShouldNotify(covariant HighlightOnUpdateTheme oldWidget) {
    return from != oldWidget.from ||
        to != oldWidget.to ||
        inDuration != oldWidget.inDuration ||
        outDuration != oldWidget.outDuration ||
        waitDuration != oldWidget.waitDuration ||
        inCurve != oldWidget.inCurve ||
        outCurve != oldWidget.outCurve ||
        borderRadius != oldWidget.borderRadius ||
        updateAfterHighlighting != oldWidget.updateAfterHighlighting;
  }

  static HighlightOnUpdateTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HighlightOnUpdateTheme>();
  }
}
