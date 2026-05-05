import 'package:flutter/material.dart';

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GooglePainter());
  }
}

class KakaoMark extends StatelessWidget {
  const KakaoMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFF191600),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'K',
          style: TextStyle(
            color: Color(0xFFFEE500),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class NaverMark extends StatelessWidget {
  const NaverMark({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Text(
          'N',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.16;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    const start = -1.15;

    Paint arc(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, start, 1.18, false, arc(const Color(0xFF4285F4)));
    canvas.drawArc(
      arcRect,
      start + 1.18,
      0.96,
      false,
      arc(const Color(0xFFEA4335)),
    );
    canvas.drawArc(
      arcRect,
      start + 2.14,
      0.96,
      false,
      arc(const Color(0xFFFBBC05)),
    );
    canvas.drawArc(
      arcRect,
      start + 3.10,
      1.62,
      false,
      arc(const Color(0xFF34A853)),
    );

    final line = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final centerY = size.height / 2;
    canvas.drawLine(
      Offset(size.width * 0.54, centerY),
      Offset(size.width * 0.88, centerY),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
