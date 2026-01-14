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
              MeshGradientColors.k1,
              MeshGradientColors.k2,
              MeshGradientColors.k3,
              MeshGradientColors.k4,
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
    final path = Path();

    // The U-shape logic provided in your previous custom paint
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, 40);

    // Conic curve to create the fluid "U" pocket
    path.conicTo(
      (size.width / 1.8),
      size.width * .9,
      0,
      size.width * 0.45,
      0.8,
    );

    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
