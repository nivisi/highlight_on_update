import 'dart:async';

import 'package:flutter/material.dart';

import 'cancellable.dart';
import 'constants.dart';
import 'highlight_on_update_theme.dart';

/// Text that is highlighted on change.
class HighlightOnUpdateText extends StatefulWidget {
  const HighlightOnUpdateText(
    this.text, {
    super.key,
    this.style,
    this.from,
    this.to,
    this.inDuration,
    this.waitDuration,
    this.outDuration,
    this.inCurve,
    this.outCurve,
    this.borderRadius,
    this.updateAfterHighlighting,
  });

  /// Text to display.
  final String text;

  /// Text style.
  final TextStyle? style;

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
  State<HighlightOnUpdateText> createState() => _HighlightOnUpdateTextState();
}

class _HighlightOnUpdateTextState extends State<HighlightOnUpdateText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late String textToDisplay;

  bool _isInitialized = false;

  Cancellable<void>? _cancellable;

  late Color _fromColor;
  late Color _toColor;
  late Duration _inDuration;
  late Duration _waitDuration;
  late Duration _outDuration;
  late Curve _inCurve;
  late Curve _outCurve;
  late BorderRadius _borderRadius;
  late bool _updateAfterHighlighting;

  @override
  void initState() {
    super.initState();

    // We initialize the widget in a post frame callback to be able to access
    // the inherited theme widget via BuildContext.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) {
        return;
      }

      _getConfig(context);

      _animationController = AnimationController(vsync: this);
      _colorAnimation = ColorTween(begin: _fromColor, end: _toColor)
          .animate(_animationController);

      textToDisplay = widget.text;

      setState(() {
        _isInitialized = true;
      });
    });
  }

  Color _getFromColor(HighlightOnUpdateTheme? theme) {
    return widget.from ?? theme?.from ?? kDefaultFromColor;
  }

  Color _getToColor(HighlightOnUpdateTheme? theme) {
    return widget.to ?? theme?.to ?? kDefaultToColor;
  }

  Curve _getInCurve(HighlightOnUpdateTheme? theme) {
    return widget.inCurve ?? theme?.inCurve ?? kDefaultInCurve;
  }

  Curve _getOutCurve(HighlightOnUpdateTheme? theme) {
    return widget.outCurve ?? theme?.outCurve ?? kDefaultOutCurve;
  }

  Duration _getInDuration(HighlightOnUpdateTheme? theme) {
    return widget.inDuration ?? theme?.inDuration ?? kDefaultInDuration;
  }

  Duration _getWaitDuration(HighlightOnUpdateTheme? theme) {
    return widget.waitDuration ?? theme?.waitDuration ?? kDefaultWaitDuration;
  }

  Duration _getOutDuration(HighlightOnUpdateTheme? theme) {
    return widget.outDuration ?? theme?.outDuration ?? kDefaultOutDuration;
  }

  BorderRadius _getBorderRadius(HighlightOnUpdateTheme? theme) {
    return widget.borderRadius ?? theme?.borderRadius ?? kDefaultBorderRadius;
  }

  bool _getUpdateAfterHighlighting(HighlightOnUpdateTheme? theme) {
    return widget.updateAfterHighlighting ??
        theme?.updateAfterHighlighting ??
        kDefaultUpdateAfterHighlighting;
  }

  void _getConfig(BuildContext context) {
    final theme = HighlightOnUpdateTheme.of(context);

    _fromColor = _getFromColor(theme);
    _toColor = _getToColor(theme);
    _inDuration = _getInDuration(theme);
    _waitDuration = _getWaitDuration(theme);
    _outDuration = _getOutDuration(theme);
    _inCurve = _getInCurve(theme);
    _outCurve = _getOutCurve(theme);
    _borderRadius = _getBorderRadius(theme);
    _updateAfterHighlighting = _getUpdateAfterHighlighting(theme);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      return;
    }

    final oldToColor = _toColor;
    final oldFromColor = _fromColor;

    _getConfig(context);

    if (_toColor != oldToColor || _fromColor != oldFromColor) {
      setState(() {
        _colorAnimation = ColorTween(begin: _fromColor, end: _toColor)
            .animate(_animationController);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  Future<void> _highlight() async {
    if (!mounted) {
      return;
    }

    // We use cancellable to prevent multiple animations if the text
    // changes too frequently.

    if (_cancellable != null) {
      _cancellable!.cancel();
    }

    _cancellable = Cancellable<void>();

    return _cancellable!.run(
      (cancellable) async {
        // Is needed to avoid the situation when this value is true
        // at the beginning of the highlighting and then will change to false,
        // meaning the text will never get updated.
        final updateAfterHighlighting = _updateAfterHighlighting;

        _animationController.stop();

        if (!updateAfterHighlighting) {
          setState(() {
            textToDisplay = widget.text;
          });
        }

        await _animationController.animateTo(
          1.0,
          duration: _inDuration,
          curve: _inCurve,
        );

        if (!mounted || cancellable.isCancelled) {
          return;
        }

        if (updateAfterHighlighting) {
          setState(() {
            textToDisplay = widget.text;
          });
        }

        await Future.delayed(_waitDuration);

        if (!mounted || cancellable.isCancelled) {
          return;
        }

        return _animationController.animateTo(
          .0,
          duration: _outDuration,
          curve: _outCurve,
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant HighlightOnUpdateText oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool isSomethingChanged = false;

    final theme = HighlightOnUpdateTheme.of(context);

    if (widget.from != oldWidget.from || widget.to != oldWidget.to) {
      _fromColor = _getFromColor(theme);
      _toColor = _getToColor(theme);

      _colorAnimation = ColorTween(begin: _fromColor, end: _toColor)
          .animate(_animationController);

      isSomethingChanged = true;
    }

    if (widget.inDuration != oldWidget.inDuration) {
      _inDuration = _getInDuration(theme);
      isSomethingChanged = true;
    }

    if (widget.waitDuration != oldWidget.waitDuration) {
      _waitDuration = _getWaitDuration(theme);
      isSomethingChanged = true;
    }

    if (widget.outDuration != oldWidget.outDuration) {
      _outDuration = _getOutDuration(theme);
      isSomethingChanged = true;
    }

    if (widget.inCurve != oldWidget.inCurve) {
      _inCurve = _getInCurve(theme);
      isSomethingChanged = true;
    }

    if (widget.outCurve != oldWidget.outCurve) {
      _outCurve = _getOutCurve(theme);
      isSomethingChanged = true;
    }

    if (widget.borderRadius != oldWidget.borderRadius) {
      _borderRadius = _getBorderRadius(theme);
      isSomethingChanged = true;
    }

    if (widget.updateAfterHighlighting != oldWidget.updateAfterHighlighting) {
      _updateAfterHighlighting = _getUpdateAfterHighlighting(theme);
      isSomethingChanged = true;
    }

    if (!mounted) {
      return;
    }

    if (isSomethingChanged) {
      setState(() {});
    }

    if (widget.text != oldWidget.text) {
      _highlight();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox.shrink();
    }

    final style = widget.style ?? const TextStyle();

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          textToDisplay,
          style: style,
        ),
        ClipRRect(
          borderRadius: _borderRadius,
          child: AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Text(
                textToDisplay,
                style: style.copyWith(
                  color: Colors.transparent,
                  backgroundColor: _colorAnimation.value,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
