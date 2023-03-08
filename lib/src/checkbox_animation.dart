import 'package:flutter/material.dart';
import 'package:flutter_checkbox_animation/src/checkbox_painter.dart';

class CheckBoxAnimation extends StatefulWidget {
  final Color? highlightColor;
  final Color? checkMarkColor;
  final double? size;
  final bool? check;
  final ValueChanged<bool>? onValueChange;

  const CheckBoxAnimation({
    super.key,
    required this.check,
    this.size,
    this.highlightColor,
    this.checkMarkColor,
    this.onValueChange,
  });

  @override
  State<CheckBoxAnimation> createState() => _CheckBoxAnimationState();
}

class _CheckBoxAnimationState extends State<CheckBoxAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _animation;
  bool check = false;

  @override
  void initState() {
    super.initState();
    check = widget.check ?? false;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: check ? 1 : 0,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void didUpdateWidget(covariant CheckBoxAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.check != widget.check) {
      if (check) {
        _controller.reset();
        _controller.forward();
      } else {
        _controller.value = 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        check = !check;
        widget.onValueChange?.call(check);
      },
      child: AnimationCheckBox(
        animation: _animation,
        check: check,
        highlightColor: widget.highlightColor,
        checkMarkColor: widget.checkMarkColor,
        size: widget.size,
      ),
    );
  }
}

class AnimationCheckBox extends AnimatedWidget {
  final bool check;
  final Color? highlightColor;
  final Color? checkMarkColor;
  final Color? outlineColor;
  final double? size;

  const AnimationCheckBox({
    super.key,
    required Animation animation,
    required this.check,
    this.highlightColor,
    this.checkMarkColor,
    this.outlineColor,
    this.size = 100,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return CustomPaint(
      size: Size(size!, size!),
      painter: CheckPainter(
        value: animation.value,
        check: check,
        highlightColor: highlightColor,
        checkMarkColor: checkMarkColor,
        outlineColor: outlineColor,
      ),
    );
  }
}
