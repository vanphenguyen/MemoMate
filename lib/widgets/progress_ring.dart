import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The big "3 / 8" ring at the top of the Today screen.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.done,
    required this.total,
    required this.doneLabel,
    required this.semanticsLabel,
    this.size = 132,
  });

  final int done;
  final int total;

  /// The small word under the numbers, e.g. "done".
  final String doneLabel;
  final String semanticsLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final complete = total > 0 && done >= total;
    return Semantics(
      label: semanticsLabel,
      child: SizedBox(
        width: size,
        height: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: total == 0 ? 0 : done / total),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          builder: (context, value, child) => CustomPaint(
            painter: _RingPainter(
              value: value,
              track: scheme.surfaceContainerHighest,
              color: complete ? const Color(0xFF2E9E6B) : scheme.primary,
            ),
            child: child,
          ),
          child: Center(
            child: complete
                ? const Icon(Icons.check_rounded, size: 56, color: Color(0xFF2E9E6B))
                : ExcludeSemantics(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$done/$total',
                          style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          doneLabel,
                          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.value, required this.track, required this.color});

  final double value;
  final Color track;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 12.0;
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final arc = rect.deflate(stroke / 2);
    canvas.drawArc(arc, 0, math.pi * 2, false, paint..color = track);
    if (value > 0) {
      canvas.drawArc(arc, -math.pi / 2, math.pi * 2 * value, false, paint..color = color);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.track != track || old.color != color;
}
