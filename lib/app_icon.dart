import 'dart:math';
import 'package:flutter/material.dart';

class AppIcon extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool jiggle;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const AppIcon({
    super.key,
    required this.label,
    required this.icon,
    required this.jiggle,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _jiggle(Animation<double> a) {
    return widget.jiggle ? sin(a.value * 2 * pi) * 0.02 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _jiggle(_controller),
          child: Transform.scale(
            scale: widget.jiggle ? 0.95 : 1.0,
            child: GestureDetector(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                        )
                      ],
                    ),
                    child: Icon(widget.icon, size: 30),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}