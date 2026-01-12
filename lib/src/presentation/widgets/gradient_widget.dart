import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:todo_withbloc/src/utils/constants/colors.dart';

class OceanWaveWidget extends StatefulWidget {
  const OceanWaveWidget({super.key});

  @override
  State<OceanWaveWidget> createState() => _OceanWaveWidgetState();
}

class _OceanWaveWidgetState extends State<OceanWaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: WavePainter(
            animationValue: _controller.value,
            colors: [
              PrimaryColors.k400,
              PrimaryColors.k800,

              PrimaryColors.k200,
            ],
          ),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;

  WavePainter({required this.animationValue, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final Rect rect = Offset.zero & size;

    // 1. Create the Main Wave Gradient
    paint.shader = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [
        0.0,
        (0.5 + 0.2 * math.sin(animationValue * 2 * math.pi)).clamp(0.0, 1.0),
        1.0,
      ],
      colors: colors,
    ).createShader(rect);

    // 2.
    // paint.shader = RadialGradient(
    //   center: Alignment(
    //     math.cos(animationValue * 2 * math.pi) * 0.5, // Center moves left/right
    //     -0.2, // Positioned near the wave crest
    //   ),
    //   radius: 1.5,
    //   focal: Alignment(math.sin(animationValue * 2 * math.pi) * 0.2, -0.5),
    //   focalRadius: 0.1,
    //   colors: colors,
    //   stops: const [0.0, 0.6, 1.0],
    // ).createShader(rect);

    final path = Path();
    double waveHeight = 40.0;
    double yOffset = size.height * 0.4;

    // path.moveTo(0, yOffset);

    // Create the Ocean Waves top edge
    // for (double x = 0; x <= size.width; x++) {
    //   double y =
    //       yOffset +
    //       math.sin(
    //             (x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi),
    //           ) *
    //           waveHeight;
    //   path.lineTo(x, y);
    // }

    // Create the "U-Shape" bottom profile
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);

    // path.quadraticBezierTo(
    //   size.width / 2,
    //   size.height + 20,
    //   0,
    //   size.height - 50,
    // );
    // path.close();

    // Draw the main filled wave body
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, yOffset);

    for (double x = size.width; x >= 0; x--) {
      double y =
          yOffset -
          math.sin(
                (x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi),
              ) *
              waveHeight;
      path.lineTo(x, y);
    }
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);

    // 2. Add a Softened Gradient Edge (Replacing the sharp line)
    // We create a separate paint for the "glow" effect on the top edge
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          10.0 // Increased width for a softer feel
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8.0,
      ); // Adds the soft blur

    // We apply a linear gradient to the stroke itself to make it fade
    edgePaint.shader =
        LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            PrimaryColors.k100,
            // Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.0), // Fades out as it goes down
          ],
        ).createShader(
          Rect.fromLTWH(0, yOffset - waveHeight, size.width, waveHeight * 2),
        );

    // We only want to draw the top edge part of the path, not the whole U-shape
    final topEdgePath = Path();
    topEdgePath.moveTo(
      0,
      yOffset + math.sin(animationValue * 2 * math.pi) * waveHeight,
    );
    for (double x = 0; x <= size.width; x++) {
      double y =
          yOffset +
          math.sin(
                (x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi),
              ) *
              waveHeight;
      topEdgePath.lineTo(x, y);
    }

    canvas.drawPath(topEdgePath, edgePaint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
