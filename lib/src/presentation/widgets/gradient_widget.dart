import 'package:flutter/material.dart';

import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:todo_withbloc/src/utils/constants/colors.dart';

class OceanWaveWidget extends StatelessWidget {
  const OceanWaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: 500,
      width: size.width,
      child: ClipPath(
        clipper: UPathClipper(),
        child: Container(
          color: Colors.amber,
          child: AnimatedMeshGradient(
            colors: [
              // PrimaryColors.k700,
              // PrimaryColors.k700,
              // PrimaryColors.k600,
              // PrimaryColors.k600,
              const Color.fromARGB(255, 157, 146, 237),
              const Color(0xFF7166C3),
              const Color.fromARGB(255, 172, 128, 234),
              const Color.fromARGB(255, 140, 129, 227),
            ],
            options: AnimatedMeshGradientOptions(
              speed: 0.01,
              frequency: 1,
              amplitude: 8,
            ),
          ),
        ),
      ),
    );
  }
}

/// A custom clipper that defines the "U" shape profile for the wave container.
class UPathClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double yOffset = 100;
    final path = Path();

    // The U-shape logic provided in your previous custom paint
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, 40);

    // Conic curve to create the fluid "U" pocket
    path.conicTo((size.width / 1.8), yOffset * 4, 0, size.height * 0.25, 0.8);

    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
