part of '../../flutter_auto_size_text.dart';

typedef _AutoSizeTextBuilder = Widget Function(BuildContext context,
    double textScaleFactor, double? groupMaxFontSize, bool overflow);

class _AutoSizeBuilder extends StatefulWidget {
  const _AutoSizeBuilder({
    super.key,
    required this.builder,
    this.overflowReplacement,
    required this.text,
    this.style,
    this.textAlign,
    this.textDirection,
    this.minLines,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.wrapWords,
    this.textScaleFactor,
    this.minFontSize,
    this.maxFontSize,
    this.stepGranularity,
    this.presetFontSizes,
    this.group,
  });

  final _AutoSizeTextBuilder builder;

  /// {@macro auto_size_text.overflowReplacement}
  final Widget? overflowReplacement;

  final TextSpan text;

  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign? textAlign;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.minLines}
  final int? minLines;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@macro auto_size_text.locale}
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.dart:ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro flutter.widgets.editableText.textScaleFactor}
  final double? textScaleFactor;

  /// {@macro auto_size_text.wrapWords}
  final bool? wrapWords;

  /// {@macro auto_size_text.minFontSize}
  final double? minFontSize;

  /// {@macro auto_size_text.maxFontSize}
  final double? maxFontSize;

  /// {@macro auto_size_text.stepGranularity}
  final double? stepGranularity;

  /// {@macro auto_size_text.presetFontSizes}
  final List<double>? presetFontSizes;

  /// {@macro auto_size_text.group}
  final AutoSizeGroup? group;

  @override
  State<_AutoSizeBuilder> createState() => _AutoSizeBuilderState();
}

class _AutoSizeBuilderState extends State<_AutoSizeBuilder> {
  @override
  void initState() {
    super.initState();
    widget.group?._register(this);
  }

  @override
  void didUpdateWidget(covariant _AutoSizeBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.group != widget.group) {
      oldWidget.group?._remove(this);
      widget.group?._register(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = widget.style ?? defaultTextStyle.style;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle.merge(
        const TextStyle(fontWeight: FontWeight.bold),
      );
    }
    if (effectiveTextStyle.fontSize == null) {
      effectiveTextStyle = effectiveTextStyle.copyWith(fontSize: 14);
    }
    final text = TextSpan(
      text: widget.text.text,
      children: widget.text.children,
      style: effectiveTextStyle,
      locale: widget.text.locale,
    );
    return _AutoSize(
      builder: widget.builder,
      overflowReplacement: widget.overflowReplacement,
      text: text,
      textAlign:
          widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection ?? Directionality.of(context),
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? defaultTextStyle.maxLines,
      locale: widget.locale ?? Localizations.maybeLocaleOf(context),
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior:
          widget.textHeightBehavior ?? defaultTextStyle.textHeightBehavior,
      wrapWords: widget.wrapWords ?? false,
      textScaleFactor: widget.textScaleFactor ?? 1,
      minFontSize: widget.minFontSize ?? 12.0,
      maxFontSize: widget.maxFontSize ?? double.infinity,
      groupMaxFontSize: widget.group?._effectiveMaxPossibleFontSize,
      stepGranularity: widget.stepGranularity ?? 1.0,
      presetFontSizes: widget.presetFontSizes,
      onMaxPossibleFontSizeChanged: widget.group != null
          ? (maxPossibleFontSize) {
              widget.group?._updateFontSize(this, maxPossibleFontSize);
            }
          : null,
    );
  }

  void _notifySync() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.group?._remove(this);
    super.dispose();
  }
}
