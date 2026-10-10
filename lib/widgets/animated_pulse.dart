import 'package:flutter/material.dart';

class AnimatedPulseBorder extends StatefulWidget {
  final Widget child;
  final Color shadowColor;
  final double borderRadius;

  const AnimatedPulseBorder({
    Key? key,
    required this.child,
    required this.shadowColor,
    this.borderRadius = 24.0,
  }) : super(key: key);

  @override
  State<AnimatedPulseBorder> createState() => _AnimatedPulseBorderState();
}

class _AnimatedPulseBorderState extends State<AnimatedPulseBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 4.0, end: 15.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor.withValues(alpha: 0.4),
                blurRadius: _animation.value,
                spreadRadius: _animation.value / 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
